{ config, lib, pkgs, ... }:
{
  imports =
  [
    # fragments
    ../frags/autosuspend/autosuspend.nix
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
        
        package = config.boot.kernelPackages.nvidiaPackages.stable; # One of stable, beta, production or vulkan_stable
    };
  };

  networking.hostName = "brahe";
  
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # GNOME
  services.xserver.displayManager.gdm.enable = true;
  #services.xserver.desktopManager.gnome.enable = true;
  services.xserver.desktopManager.cinnamon.enable = true;

  # dwm
  services.xserver.windowManager.dwm.enable = true;

  # kde
  #services.displayManager.sddm.enable = true;
  #services.desktopManager.plasma6.enable = true;

  
  # Set X11 monitor R&R

  services.autorandr.enable = true;
  services.autorandr.profiles."default" = {
    fingerprint = { 
      "HDMI-0" = "00ffffffffffff004c2d5b73000e000101210103808e50780aa833ab5045a5270d4848bdef80714f81c0810081809500a9c0b300d1c008e80030f2705a80b0588a00501d7400001e565e00a0a0a029503020350000000000001a000000fd00184b0f873c000a202020202020000000fc0053414d53554e470a202020202001db02035af05561101f041305142021225d5e5f606566626403125a2f0d5707090707150750570700675400830f0000e2004fe305c3016e030c003000b8442800800102030467d85dc40178800be3060d01e30f01e0e5018b849001000000000000000000000000000000000000000000000000000000000000000000000000000b";
    };

    config."HDMI-0" = {
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

  # Enable CUPS to print documents.
  services.printing.enable = true;

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };
  
  # enable auto-upgrade on reboot
  system.autoUpgrade.enable = true;
  
  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 22 8000 ];
  
  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true; # We can just leave passwd auth on for the desktop.
    settings = {
      PasswordAuthentication = true;
      PermitRootLogin = "no";
    };
  };
  
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
