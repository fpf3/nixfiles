{pkgs, lib, config, withGui ? true}:
let 
  listIf = (cond: l: if cond then l else []);
in
{
  # steam system config
  programs.steam = lib.mkIf(withGui) {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };

  services.udev.packages = listIf(withGui) [ pkgs.dolphin-emu ];
}
