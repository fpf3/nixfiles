{config, lib, pkgs, ...}: 
let 
  contport = (import ../util/portpattern.nix);
  nintendomaker = {config, pkgs, hostaddr, localaddr, rdpPort}:
  {
    autoStart = true;
    privateNetwork = true;
    hostAddress = hostaddr;
    localAddress = localaddr;

    forwardPorts = (contport rdpPort);
    
    bindMounts."fileshare" = {
      isReadOnly = true;
      mountPoint = "/home/melonDS/Desktop/ds_files";
      hostPath = "/home/fred/ds_share";
    };


    config = { config, pkgs, ...}: {
      users.users.melonDS = {
          createHome = true;
          description = "DS Gamer";
          shell = "${pkgs.bash}/bin/bash";
          isNormalUser = true;
      };
      
      networking.firewall.enable = true;
      networking.firewall.allowedUDPPorts = [ 7063 7064 ];
      
      services.openssh.enable = true;
      services.xserver.enable = true;
      services.displayManager.sddm.enable = true;
      #services.displayManager.autoLogin = {
      #  enable = true;
      #  user = "melonDS";
      #};
      services.desktopManager.plasma6.enable = true;

      services.xrdp.enable = true;
      services.xrdp.defaultWindowManager = "startplasma-x11";
      services.xrdp.openFirewall = true;
      services.xrdp.port = rdpPort;

      environment.systemPackages = with pkgs; [
        melonDS
        zfs
        firefox
      ];
      #++ [
      #  pkgs.callPackage ../../custom_pkgs/dwm/default.nix {};
      #];

      system.stateVersion = "23.11";
    };
  };
in
{
  containers.nintendo1 = nintendomaker { config=config; pkgs=pkgs; hostaddr = "10.10.34.10"; localaddr = "10.10.34.11"; rdpPort = 3389; };
  containers.nintendo2 = nintendomaker { config=config; pkgs=pkgs; hostaddr = "10.10.35.10"; localaddr = "10.10.35.11"; rdpPort = 3390; };
  containers.nintendo3 = nintendomaker { config=config; pkgs=pkgs; hostaddr = "10.10.36.10"; localaddr = "10.10.36.11"; rdpPort = 3391; };
  containers.nintendo4 = nintendomaker { config=config; pkgs=pkgs; hostaddr = "10.10.37.10"; localaddr = "10.10.37.11"; rdpPort = 3392; };
}
