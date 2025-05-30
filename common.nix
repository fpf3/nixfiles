# Common settings between all machines
{config, lib, pkgs, ...}:
let
  grub_bg = builtins.path { path=./frags/grub/zentree_1.png; };
in
{
  # ZFS wants this set. Why? XXX
  networking.hostId = "b2c73136"; # just a random number...

  # Set your time zone.
  time.timeZone = "America/New_York";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # allow unfree $oftware
  nixpkgs.config.allowUnfree = true;

  networking.resolvconf.enable = true;

  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    efiInstallAsRemovable = true;
    mirroredBoots = [
        { devices = [ "nodev" ]; path = "/boot"; }
    ];
    configurationLimit = 5;
    splashImage = grub_bg;
    font = "${pkgs.nerd-fonts._0xproto}/share/fonts/truetype/NerdFonts/0xProto/0xProtoNerdFontMono-Regular.ttf";
    fontSize = 32;
  };
  
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

  # Configure keymap in X11
  services.xserver.xkb.layout = "us";

  nix.optimise = {
    automatic = true;
    dates = [ "3:00" ];
  };
  
  # enable auto-upgrade on reboot
  system.autoUpgrade.enable = true;

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
