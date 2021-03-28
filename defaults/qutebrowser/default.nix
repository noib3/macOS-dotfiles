{ font, colors }:
let
  home-page = "https://google.com";
in
{
  searchEngines = {
    "DEFAULT" = "https://google.com/search?q={}";
    "yt" = "https://youtube.com/results?search_query={}";
    "nixo" = "https://search.nixos.org/options?channel=20.09&query={}";
    "nixp" = "https://search.nixos.org/packages?channel=20.09&query={}";
  };

  settings = {
    fonts = {
      default_family = font.family;
      default_size = font.size;
    };

    colors = {
      tabs = {
        odd.bg = colors.tabs.unfocused.bg;
        odd.fg = colors.tabs.unfocused.fg;
        even.bg = colors.tabs.unfocused.bg;
        even.fg = colors.tabs.unfocused.fg;
        selected.odd.bg = colors.tabs.focused.bg;
        selected.odd.fg = colors.tabs.focused.fg;
        selected.even.bg = colors.tabs.focused.bg;
        selected.even.fg = colors.tabs.focused.fg;
      };

      hints = {
        bg = colors.hints.bg;
        fg = colors.hints.fg;
        match.fg = colors.hints.match.fg;
      };

      completion = {
        category.bg = colors.completion.category.bg;
        category.fg = colors.completion.category.bg;
        category.border.top = colors.completion.bg;
        category.border.bottom = colors.completion.bg;

        odd.bg = colors.completion.bg;
        even.bg = colors.completion.bg;

        fg = [
          colors.completion.fg
          colors.completion.url.fg
          colors.completion.fg
        ];

        item.selected.bg = colors.completion.selected.bg;
        item.selected.fg = colors.completion.selected.fg;
        item.selected.border.top = colors.completion.bg;
        item.selected.border.bottom = colors.completion.bg;

        item.selected.match.fg = colors.completion.selected.bg;
      };

      statusbar = {
        normal.bg = colors.statusbar.bg;
        normal.fg = colors.statusbar.fg;
        private.bg = colors.statusbar.private.bg;
        private.fg = colors.statusbar.private.fg;
        command = {
          bg = colors.statusbar.bg;
          fg = colors.statusbar.fg;
          private.bg = colors.statusbar.private.bg;
          private.fg = colors.statusbar.private.fg;
        };
      };

      messages = {
        error = {
          bg = colors.messages.error.bg;
          fg = colors.messages.error.fg;
          border = colors.messages.error.bg;
        };
      };
    };

    completion = {
      show = "auto";
      shrink = true;
      timestamp_format = "";
      scrollbar.padding = 0;
    };

    hints = {
      border = "none";
      radius = 1;
    };

    messages.timeout = 1000;
    content.autoplay = false;
    downloads.remove_finished = 1000;

    input.insert_mode = {
      auto_load = true;
      leave_on_load = true;
    };

    scrolling = {
      bar = "never";
      smooth = true;
    };

    statusbar = {
      # Hide the statusbar when not in command mode.
      show = "never";
      widgets = [ ];
    };

    tabs = {
      # Hide the tab bar if only one tab is open.
      show = "multiple";
      # Close the window when the last tab is closed.
      last_close = "close";
      # Restore the previously saved mode when switching tabs;
      mode_on_change = "restore";

      close_mouse_button = "right";
    };

    url = {
      default_page = home-page;
      start_pages = [ home-page ];
    };

    zoom.default = "130%";
  };

  keyMappings = {
    "<Super-l>" = "o";
    "<Super-t>" = "O";
  };

  keyBindings = {
    normal = {
      "<Super-r>" = "config-source";

      "<Super-c>" = "fake-key <Ctrl-c>";

      "<Super-Up>" = "scroll-to-perc 0";
      "<Super-Down>" = "scroll-to-perc";
      "<Super-Left>" = "back";
      "<Super-Right>" = "forward";

      "<Super-n>" = "open -w";
      "<Super-Shift-p>" = "open -p";

      "<Super-w>" = "tab-close";
      "<Super-1>" = "tab-focus 1";
      "<Super-2>" = "tab-focus 2";
      "<Super-3>" = "tab-focus 3";
      "<Super-4>" = "tab-focus 4";
      "<Super-5>" = "tab-focus 5";
      "<Super-6>" = "tab-focus 6";
      "<Super-7>" = "tab-focus 7";
      "<Super-8>" = "tab-focus 8";
      "<Super-9>" = "tab-focus 9";
      "<Super-0>" = "tab-focus 10";

      "gh" = "open ${home-page}";
      "th" = "open -t ${home-page}";

      "gma" = "open https://mail.protonmail.com/inbox";
      "tma" = "open -t https://mail.protonmail.com/inbox";

      "gkp" = "open https://keep.google.com";
      "tkp" = "open -t https://keep.google.com";

      "gyt" = "open https://youtube.com";
      "tyt" = "open -t https://youtube.com";

      "gre" = "open https://reddit.com";
      "tre" = "open -t https://reddit.com";

      "gdf" = "open https://github.com/noib3/dotfiles";
      "tdf" = "open -t https://github.com/noib3/dotfiles";

      "grhm" = "open https://github.com/nix-community/home-manager/find/master";
      "trhm" = "open -t https://github.com/nix-community/home-manager/find/master";

      "gbg" = "open https://rarbgunblocked.org/torrents.php";
      "tbg" = "open -t https://rarbgunblocked.org/torrents.php";

      "glg" = "open https://libgen.li";
      "tlg" = "open -t https://libgen.li";

      "gn26" = "open https://app.n26.com/account";
      "tn26" = "open -t https://app.n26.com/account";

      "gwi" = "open https://wise.com/user/account/";
      "twi" = "open -t https://wise.com/user/account/";

      "gt0" = "open https://www.tradezero.co/account/";
      "tt0" = "open -t https://www.tradezero.co/account/";

      "gtw" = "open https://manage.tastyworks.com/index.html";
      "ttw" = "open -t https://manage.tastyworks.com/index.html";

      "gtra" = "open http://localhost:9091/transmission/web/";
      "ttra" = "open -t http://localhost:9091/transmission/web/";

      "gbm" = "open http://localhost:5001";
      "tbm" = "open -t http://localhost:5001";

      "gsy" = "open http://localhost:8384";
      "tsy" = "open -t http://localhost:8384";

      "grsy" = "open https://46.101.51.224:8384";
      "trsy" = "open -t https://46.101.51.224:8384";
    };

    command = {
      "<Super-w>" = "tab-close";

      "<Super-c>" = "completion-item-yank";
      "<Super-v>" = "fake-key --global <Ctrl-v>";

      "<Super-Left>" = "rl-beginning-of-line";
      "<Super-Right>" = "rl-end-of-line";
      "<Alt-Backspace>" = "rl-backward-kill-word";
      "<Super-Backspace>" = "rl-unix-line-discard";
    };

    insert = {
      "<Super-w>" = "tab-close";

      "<Super-c>" = "fake-key <Ctrl-c>";
      "<Super-v>" = "fake-key <Ctrl-v>";

      "<Super-Left>" = "fake-key <Home>";
      "<Super-Right>" = "fake-key <End>";
      "<Alt-Backspace>" = "fake-key <Ctrl-Backspace>";
      "<Super-Backspace>" = "fake-key <Shift-Home><Delete>";

      "<Super-1>" = "tab-focus 1";
      "<Super-2>" = "tab-focus 2";
      "<Super-3>" = "tab-focus 3";
      "<Super-4>" = "tab-focus 4";
      "<Super-5>" = "tab-focus 5";
      "<Super-6>" = "tab-focus 6";
      "<Super-7>" = "tab-focus 7";
      "<Super-8>" = "tab-focus 8";
      "<Super-9>" = "tab-focus 9";
      "<Super-0>" = "tab-focus 10";
    };
  };

  extraConfig = ''
    config.unbind("gm")
    config.unbind("gd")
    config.unbind("gb")
    config.unbind("tl")
    config.unbind("gt")

    c.tabs.padding = {"bottom": 1, "left": 7, "right": 7, "top": 1}

    config.load_autoconfig(True)
  '';
}