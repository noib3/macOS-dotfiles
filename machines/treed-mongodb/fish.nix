{
  shellAliases = {
    reboot = "sudo shutdown -r now";
    shutdown = "sudo shutdown now";
  };

  shellAbbrs = {
    nrs = "sudo nixos-rebuild switch";
  };
}
