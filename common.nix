# Common settings between all machines
{config, lib, pkgs, ...}:
{
  # ZFS wants this set. Why? XXX
  networking.hostId = "b2c73136"; # just a random number...

  # Set your time zone.
  time.timeZone = "America/New_York";

  # list of unfree $oftware to allow
  nixpkgs.config.allowUnfreePredicate = pkg:
  builtins.elem (lib.getName pkg) [
      "joypixels"
      "nvidia-persistenced"
      "nvidia-settings"
      "nvidia-x11"
      "steam"
      "steam-original"
      "steam-run"
      "steam-unwrapped"
    ];

  # List packages installed in system profile.
   environment.systemPackages = with pkgs; [
     wget
     xorg.xhost
   ];

  # fonts
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-color-emoji
    #joypixels # figure out how to accept license declaratively
  ];

  # enable avahi
  services.avahi = {
    enable = true;
    
    ipv4 = true;
    nssmdns4 = true;

    ipv6 = false;
    nssmdns6 = false;

    publish = {
      enable = true;
      domain = true;
      addresses = true;
    };

    openFirewall = true;
    domainName = "local";
  };
}
