{ config, lib, pkgs, ... }:
let
  unstable = import <nixos-unstable> { };

  colorscheme = "onedark";
  font = "fira-code";

  dirs = {
    defaults = ../../defaults;
    colorscheme = ../../colorschemes + "/${colorscheme}";
    font = ./fonts + "/${font}";
    screenshots = config.home.homeDirectory + "/sync/screenshots";
  };

  desktop-items = with pkgs; {
    qutebrowser = makeDesktopItem
      {
        name = "qutebrowser";
        desktopName = "qutebrowser";
        exec = "${pkgs.qutebrowser}/bin/qutebrowser";
        mimeType = lib.concatStringsSep ";" [
          "text/html"
          "x-scheme-handler/about"
          "x-scheme-handler/http"
          "x-scheme-handler/https"
          "x-scheme-handler/unknown"
        ];
        icon = "qutebrowser";
      };
  };

  scripts.bspwm = with pkgs; {
    mpv-focus-prev = writeShellScriptBin "mpv-focus-prev"
      (builtins.readFile (dirs.defaults + /bspwm/scripts/mpv-focus-prev.sh));
  };

  scripts.dmenu = with pkgs; {
    open = writeShellScriptBin "dmenu-open"
      (builtins.readFile (dirs.defaults + /dmenu/scripts/dmenu-open.sh));

    run = writeShellScriptBin "dmenu-run" "dmenu_run -p 'Run>'";

    wifi = writers.writePython3Bin "dmenu-wifi"
      { libraries = [ python38Packages.pygobject3 ]; }
      (builtins.readFile (dirs.defaults + /dmenu/scripts/dmenu-wifi.py));

    bluetooth = writers.writePython3Bin "dmenu-bluetooth" { }
      (builtins.readFile (dirs.defaults + /dmenu/scripts/dmenu-bluetooth.py));

    powermenu = writers.writePython3Bin "dmenu-powermenu" { }
      (builtins.readFile (dirs.defaults + /dmenu/scripts/dmenu-powermenu.py));

    xembed-qutebrowser = writeShellScriptBin "dmenu-xembed-qute"
      (
        import (dirs.defaults + /dmenu/scripts/dmenu-xembed.sh.nix) {
          font = (import (dirs.font + /qutebrowser.nix)).dmenu;
          colors = (import (dirs.colorscheme + /qutebrowser.nix)).dmenu;
        }
      );
  };

  scripts.lf = with pkgs; {
    cleaner = writeShellScriptBin "cleaner"
      (builtins.readFile (dirs.defaults + /lf/cleaner.sh));

    previewer = writeShellScriptBin "previewer"
      (builtins.readFile (dirs.defaults + /lf/previewer.sh));
  };

  scripts.fzf = with pkgs; {
    fuzzy-ripgrep = writeShellScriptBin "fuzzy-ripgrep"
      (builtins.readFile (dirs.defaults + /fzf/scripts/fuzzy-ripgrep.sh));

    rg-previewer = writeShellScriptBin "rg-previewer"
      (builtins.readFile (dirs.defaults + /fzf/scripts/rg-previewer.sh));

    ueberzug-previews = writeShellScriptBin "fzf-ueberzug-previews"
      (builtins.readFile (dirs.defaults + /fzf/scripts/ueberzug-previews.sh));
  };

  scripts.qutebrowser = with pkgs; {
    add-torrent = writeShellScriptBin "add-torrent"
      (builtins.readFile (dirs.defaults + /qutebrowser/scripts/add-torrent.sh));

    fill-bitwarden = writers.writePython3Bin "fill-bitwarden"
      { libraries = [ python38Packages.tldextract ]; }
      (builtins.readFile (dirs.defaults + /qutebrowser/scripts/fill-bitwarden.py));
  };

  scripts.transmission = with pkgs; {
    notify-done = writeShellScriptBin "transmission-notify-done"
      (
        import (dirs.defaults + /transmission/scripts/notify-done-linux.sh.nix) {
          inherit pkgs;
        }
      );
  };

  userScripts = with pkgs; [
    scripts.dmenu.open
    scripts.dmenu.run
    scripts.dmenu.wifi
    scripts.dmenu.bluetooth
    scripts.dmenu.powermenu
    scripts.dmenu.xembed-qutebrowser

    scripts.lf.cleaner
    scripts.lf.previewer

    scripts.fzf.fuzzy-ripgrep
    scripts.fzf.rg-previewer
    scripts.fzf.ueberzug-previews

    scripts.transmission.notify-done

    (hiPrio (writeShellScriptBin "lf" (
      import (dirs.defaults + /lf/launcher.sh.nix) { inherit pkgs; }
    )))

    (writeScriptBin "take-screenshot" (
      import ./scripts/take-screenshot.nix {
        screenshots-dir = dirs.screenshots;
      }
    ))

    (writeScriptBin "volumectl" (import ./scripts/volumectl.nix))
  ];

  configs.alacritty =
    let
      default = (
        import (dirs.defaults + /alacritty) {
          pkgs = unstable;
          font = import (dirs.font + /alacritty.nix);
          colors = import (dirs.colorscheme + /alacritty.nix);
        }
      );
    in
    lib.attrsets.recursiveUpdate
      default
      (import ./overrides/alacritty.nix { default = default; });

  configs.bat = import (dirs.defaults + /bat);

  configs.bspwm = (
    import (dirs.defaults + /bspwm) {
      colors = import (dirs.colorscheme + /bspwm.nix);
      scripts = scripts.bspwm;
    }
  );

  configs.direnv = import (dirs.defaults + /direnv);

  configs.dunst = (
    import (dirs.defaults + /dunst) {
      inherit pkgs;
      font = import (dirs.font + /dunst.nix);
      colors = import (dirs.colorscheme + /dunst.nix);
    }
  );

  configs.fd =
    let
      default = import (dirs.defaults + /fd);
    in
    import ./overrides/fd.nix { default = default; };

  configs.firefox = (
    import (dirs.defaults + /firefox) {
      font = import (dirs.font + /firefox.nix);
      colors = import (dirs.colorscheme + /firefox.nix);
    }
  );

  configs.fish = lib.attrsets.recursiveUpdate
    (
      import (dirs.defaults + /fish) {
        inherit pkgs;
        colors = import (dirs.colorscheme + /fish.nix);
      }
    )
    (import ./overrides/fish.nix);

  configs.fzf = (
    import (dirs.defaults + /fzf) {
      colors = import (dirs.colorscheme + /fzf.nix);
    }
  );

  configs.fusuma = import (dirs.defaults + /fusuma);

  configs.git = import (dirs.defaults + /git);

  configs.gpgAgent = import (dirs.defaults + /gpg/gpg-agent.nix);

  configs.lazygit = import (dirs.defaults + /lazygit);

  configs.lf = lib.attrsets.recursiveUpdate
    (import (dirs.defaults + /lf) {
      previewer = scripts.lf.previewer;
      cleaner = scripts.lf.cleaner;
    })
    (import ./overrides/lf.nix);

  configs.mpv = import (dirs.defaults + /mpv);

  configs.picom = import (dirs.defaults + /picom);

  configs.polybar = (
    import (dirs.defaults + /polybar) {
      inherit lib;
      fonts = import (dirs.font + /polybar.nix);
      colors = import (dirs.colorscheme + /polybar.nix);
    }
  );

  configs.qutebrowser = (
    import (dirs.defaults + /qutebrowser) {
      font = import (dirs.font + /qutebrowser.nix);
      colors = import (dirs.colorscheme + /qutebrowser.nix);
      scripts = scripts.qutebrowser;
    }
  );

  configs.redshift = import (dirs.defaults + /redshift);

  configs.starship = (
    import (dirs.defaults + /starship) {
      inherit lib;
    }
  );

  configs.sxhkd = import (dirs.defaults + /sxhkd);

  configs.ssh = import (dirs.defaults + /ssh);

  configs.tridactyl = (
    import (dirs.defaults + /tridactyl) {
      font = import (dirs.font + /tridactyl.nix);
      colors = import (dirs.colorscheme + /tridactyl.nix);
    }
  );

  configs.udiskie = import (dirs.defaults + /udiskie);

  configs.vivid = (
    import (dirs.defaults + /vivid) {
      colors = import (dirs.colorscheme + /vivid.nix);
    }
  );

  configs.zathura = (
    import (dirs.defaults + /zathura) {
      font = import (dirs.font + /zathura.nix);
      colors = import (dirs.colorscheme + /zathura.nix);
    }
  );

  dmenu = (
    import (dirs.defaults + /dmenu) {
      inherit pkgs;
      font = import (dirs.font + /dmenu.nix);
      colors = import (dirs.colorscheme + /dmenu.nix);
    }
  );

  devTools = with pkgs; [
    gcc
    gnumake
  ];

  language-servers = with pkgs; [
    sumneko-lua-language-server
    nodePackages.bash-language-server
    nodePackages.pyright
    nodePackages.vim-language-server
  ];
in
{
  imports = [
    ../../modules/programs/fd.nix
    ../../modules/programs/tridactyl.nix
    ../../modules/programs/vivid.nix
    ../../modules/services/fusuma.nix
    ../../modules/services/mpris.nix
  ];

  home = {
    username = "noib3";
    homeDirectory = "/home/noib3";
    stateVersion = "21.03";

    packages = with pkgs; [
      any-nix-shell
      atool
      bitwarden
      bitwarden-cli
      calcurse
      calibre
      chafa
      delta
      dmenu
      dragon-drop
      evemu
      evtest
      feh
      ffmpegthumbnailer
      file
      fusuma
      glxinfo
      git-crypt
      gotop
      graphicsmagick-imagemagick-compat
      inkscape
      libnotify
      lua5_4
      jmtpfs
      keyutils
      mediainfo
      mkvtoolnix-cli
      neovim-nightly
      networkmanager_dmenu
      (nerdfonts.override {
        fonts = [
          "FiraCode"
          "JetBrainsMono"
          "RobotoMono"
        ];
      })
      nixpkgs-fmt
      nodejs
      noto-fonts-emoji
      pandoc
      pfetch
      pick-colour-picker
      pinentry_qt5 # GnuPG's cli interface to passphrase input
      poppler_utils
      protonmail-bridge
      (python39.withPackages (
        ps: with ps; [
          autopep8
          ipython
          isort
          pynvim
        ]
      ))
      ripgrep
      rustup
      scrot
      speedtest-cli
      unstable.texlive.combined.scheme-full
      transmission-remote-gtk
      tree
      ueberzug
      unclutter-xfixes
      unzip
      vimv
      wmctrl
      xbanish
      xclip
      xdotool
      xorg.xev
      xorg.xwininfo
      yarn

      xdo # used by scripts.bspwm.mpv-focus-prev
      pciutils # for lspci
      desktop-items.qutebrowser

      proselint
    ]
    ++ devTools
    ++ language-servers
    ++ userScripts;

    sessionVariables = {
      EDITOR = "nvim";
      MANPAGER = "nvim -c 'set ft=man' -";
      LANG = "en_US.UTF-8";
      LC_ALL = "en_US.UTF-8";
      COLORTERM = "truecolor";
      LS_COLORS = "$(vivid generate current)";
      LF_ICONS = (builtins.readFile (dirs.defaults + /lf/LF_ICONS));
      HISTFILE = "${config.xdg.cacheHome}/bash/bash_history";
      LESSHISTFILE = "${config.xdg.cacheHome}/less/lesshst";
      RIPGREP_CONFIG_PATH = dirs.defaults + /ripgrep/ripgreprc;
      SYNCDIR = builtins.toString ../../..;
    };
  };

  nixpkgs.overlays = [
    (self: super: {
      lf = unstable.lf;
    })

    (import (builtins.fetchTarball {
      url = https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz;
    }))
  ];

  xdg.configFile = {
    "fusuma/config.yml" = {
      source = (dirs.defaults + /fusuma/config.yml);
    };

    "nvim" = {
      source = (dirs.defaults + /neovim);
      recursive = true;
    };

    "nvim/lua/colorscheme/init.lua" = {
      text = (
        import (dirs.defaults + /neovim/lua/colorscheme/init.lua.nix) {
          inherit lib;
          colors = import (dirs.colorscheme + /neovim.nix);
        }
      );
    };

    "nvim/lua/plugins/config/lsp/sumneko_paths.lua" = {
      text = (
        import (dirs.defaults + /neovim/lua/plugins/config/lsp/sumneko_paths.lua.nix) {
          inherit pkgs;
        }
      );
    };

    "redshift/hooks/notify-change" = {
      text = (
        import (dirs.defaults + /redshift/scripts/notify-change-linux.sh.nix) {
          inherit pkgs;
        }
      );
      executable = true;
    };
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = [ "qutebrowser.desktop" ];
      "application/pdf" = [ "org.pwmt.zathura.desktop" ];
    };
  };

  fonts.fontconfig = {
    enable = true;
  };

  programs.home-manager = {
    enable = true;
  };

  programs.alacritty = {
    enable = true;
  } // configs.alacritty;

  programs.bat = {
    enable = true;
  } // configs.bat;

  programs.direnv = {
    enable = true;
  } // configs.direnv;

  programs.fd = {
    enable = true;
  } // configs.fd;

  programs.firefox = {
    enable = true;
  } // configs.firefox;

  programs.fish = {
    enable = true;
    package = unstable.fish;
  } // configs.fish;

  programs.fzf = {
    enable = true;
    package = unstable.fzf;
  } // configs.fzf;

  programs.git = {
    enable = true;
  } // configs.git;

  programs.gpg = {
    enable = true;
  };

  programs.lazygit = {
    enable = true;
  } // configs.lazygit;

  programs.lf = {
    enable = true;
  } // configs.lf;

  programs.mpv = {
    enable = true;
  } // configs.mpv;

  programs.qutebrowser = {
    enable = true;
    package = unstable.qutebrowser;
  } // configs.qutebrowser;

  programs.ssh = {
    enable = true;
  } // configs.ssh;

  programs.starship = {
    enable = true;
    package = unstable.starship;
  } // configs.starship;

  programs.tridactyl = {
    enable = true;
  } // configs.tridactyl;

  programs.vivid = {
    enable = true;
  } // configs.vivid;

  programs.zathura = {
    enable = true;
  } // configs.zathura;

  services.dunst = {
    enable = true;
  } // configs.dunst;

  # services.fusuma = {
  #   enable = true;
  # } // configs.fusuma;

  services.gpg-agent = {
    enable = true;
  } // configs.gpgAgent;

  services.mpris = {
    enable = true;
  };

  services.picom = {
    enable = true;
    package = unstable.picom;
  } // configs.picom;

  services.polybar = {
    enable = true;
    package = pkgs.polybar.override {
      pulseSupport = true;
    };
  } // configs.polybar;

  services.redshift = {
    enable = true;
  } // configs.redshift;

  services.sxhkd = {
    enable = true;
  } // configs.sxhkd;

  services.udiskie = {
    enable = true;
  } // configs.udiskie;

  xsession = {
    enable = true;

    windowManager.bspwm = {
      enable = true;
    } // configs.bspwm;

    pointerCursor = {
      package = pkgs.vanilla-dmz;
      name = "Vanilla-DMZ";
      size = 16;
      defaultCursor = "left_ptr";
    };

    profileExtra = ''
      ${pkgs.feh}/bin/feh --bg-fill --no-fehbg \
        ${builtins.toString (dirs.colorscheme + /background.png)}
    '';
  };
}
