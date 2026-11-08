{ config, lib, pkgs, ... }:
{
  imports =
  [
    # fragments
    ../frags/autosuspend/autosuspend.nix
    ../frags/lightdm/lightdm.nix
    # User-specific config
    (import ../users/fred/fred.nix {pkgs=pkgs; config=config; lib=lib;})
    (import ../users/theater/theater.nix {pkgs=pkgs; config=config; lib=lib;})
  ];

  boot.kernelParams = [
    "nvidia_drm.fbdev=0" # Explicitly disable fbdev
  ];

  # Kernel configuration
  boot.kernelPackages = pkgs.linuxPackages; # default

  # peripherals configuration
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware = {
    graphics.enable = true;
    nvidia = {
        modesetting.enable = true; # required

        powerManagement = {
            enable = true; # Enable this if you have graphical corruption issues waking up from sleep
            finegrained = false; # Turn off GPU when not in use. "Turing" or newer.
        };
        
        open = false; # Open-source module (not nouveau, the upstream NVIDIA one...)

        nvidiaSettings = true; # nvidia-settings manager
        
        package = config.boot.kernelPackages.nvidiaPackages.legacy_580; # One of stable, beta, production or vulkan_stable
    };
  };

  networking.hostName = "brahe";
  
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # GNOME
  #services.xserver.displayManager.gdm.enable = true;
  #services.xserver.desktopManager.gnome.enable = true;
  services.xserver.desktopManager.cinnamon.enable = true;
  #services.xserver.desktopManager.xfce.enable = true;

  # dwm
  services.xserver.windowManager.dwm.enable = true;

  # Set X11 monitor R&R

  services.autorandr.enable = true;
  services.autorandr.profiles."default" = {
    fingerprint = { 
      "HDMI-1" = "00ffffffffffff001e6d010001010101011d010380a05a780aee91a3544c99260f5054a1080031404540614071408180d1c00101010104740030f2705a80b0588a0040846300001e023a801871382d40582c450040846300001e000000fd0018781e871e000a202020202020000000fc004c472054560a20202020202020018c02033ff1565f101f0413051403021220212215015d5e6263643f40230957076e030c002000b83c20008001020304e200cfe305c000e50e60616566e3060d01662150b051001b304070360040846300001e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e2";
    };

    config."HDMI-1" = {
      enable = true;
      primary = true;
      #scale = { x = 0.7; y = 0.7; };
      position = "0x0";
      mode = "3840x2160";
      rate = "59.94";
      dpi = 97;
    };
  };
  
  # Enable natural scrolling
  services.libinput.touchpad.naturalScrolling = true; # This is for libinput, but it seems to also work in X11

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };
  
  # enable auto-upgrade on reboot
  system.autoUpgrade.enable = true;
  
  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 22 8000 ];
  
  # Enable the OpenSSH daemon.
  services.openssh ={
    enable = true; # We can just leave passwd auth on for the desktop.
    settings = {
      PasswordAuthentication = true;
      PermitRootLogin = "no";
    };
  };

  services.joycond.enable = true;
  
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
