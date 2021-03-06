{ modulesPath, lib, pkgs, ... }:
let
  unstable = import <nixos-unstable> { };

  configs = {
    couchdb =
      (import ../../defaults/couchdb { inherit lib; })
      // (import ./overrides/couchdb.nix);
    syncthing = import ./overrides/syncthing.nix;
  };
in
{
  imports = [
    (modulesPath + "/virtualisation/digital-ocean-config.nix")
  ];

  swapDevices = [
    {
      device = "/var/swap";
      size = 2048;
    }
  ];

  users = {
    users = {
      "noib3" = {
        home = "/home/noib3";
        shell = pkgs.fish;
        isNormalUser = true;
        extraGroups = [ "wheel" ];
        openssh.authorizedKeys.keyFiles = [
          ./ssh-authorized-keys/noib3.pub
        ];
      };

      "couchdb" = {
        home = "/home/couchdb";
        shell = pkgs.fish;
        isSystemUser = true;
        createHome = true;
        extraGroups = [ "couchdb" ];
      };
    };
  };

  environment.systemPackages = with pkgs; [
    vim
  ];

  security.sudo = {
    wheelNeedsPassword = false;
  };

  networking = {
    hostName = "archiv3";
    firewall = {
      allowedTCPPorts = [
        5984
        8384
      ];
    };
  };

  programs.fish = {
    enable = true;
  };

  services.couchdb = {
    enable = true;
    package = unstable.couchdb3;
  } // configs.couchdb;

  services.syncthing = {
    enable = true;
    package = unstable.syncthing;
  } // configs.syncthing;
}
