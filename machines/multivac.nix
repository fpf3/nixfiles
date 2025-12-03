{ config, lib, pkgs, ... }:
let
  grub_bg = builtins.path { path=../frags/grub/zentree_1.png; };
in
{
  imports =
    [
     # User-specific config
     (import ../users/fred/fred.nix {inherit pkgs lib config;})
    ];

  nixpkgs.config.allowUnfree = true;

  # bootloader config
  
  # Bootloader.
  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
    useOSProber = true;
    configurationLimit = 5;
    splashImage = grub_bg;
    font = "${pkgs.nerd-fonts._0xproto}/share/fonts/truetype/NerdFonts/0xProto/0xProtoNerdFontMono-Regular.ttf";
    fontSize = 12;
  };

  swapDevices = [ ];

  # Kernel configuration
  boot.kernelPackages = pkgs.linuxPackages; # default

  # peripherals configuration

  networking.hostName = "multivac";
  
  networking.wireless.iwd.enable = true;
  networking.networkmanager.wifi.backend = "iwd";
  
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  services.xserver.displayManager.lightdm.enable = true;
  #services.xserver.displayManager.gdm.enable = true;
  #services.displayManager.sddm.enable = true;
  services.xserver.windowManager.dwm.enable = true;
  #services.xserver.desktopManager.cinnamon.enable = true;

  # kde
  #services.displayManager.sddm.enable = true;
  #services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";
  
  # Enable natural scrolling
  services.libinput.touchpad.naturalScrolling = true; # This is for libinput, but it seems to also work in X11

  # Enable CUPS to print documents.
  services.printing.enable = true;

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };
  
  # enable auto-upgrade on reboot
  #system.autoUpgrade.enable = true;
  
  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 22 8000 ];
  
  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?
}
