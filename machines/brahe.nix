{ config, lib, pkgs, ... }:
{
  nixpkgs.config.allowUnfreePredicate = pkg:
  builtins.elem (lib.getName pkg) [
      "nvidia-x11"
      "nvidia-settings"
      "nvidia-persistenced"
      "steam"
      "steam-original"
      "steam-run"
    ];

  # bootloader config
  boot.loader.grub = {
	enable = true;
	efiSupport = true;
	efiInstallAsRemovable = true;
	mirroredBoots = [
		{ devices = [ "nodev" ]; path = "/boot"; }
	];
  };
  
  fileSystems."/" = {
  	device = "/dev/disk/by-uuid/328a552a-cd07-42cd-b32e-0decb0f4a6c0";
  	fsType = "ext4";
  	neededForBoot = true;
  };
  
  fileSystems."/boot" = {
  	device = "/dev/disk/by-uuid/F620-F4DF";
  	fsType = "vfat";
  };

  swapDevices = [ ];
  

  # Kernel configuration
  boot.kernelPackages = pkgs.linuxPackages; # default

  # peripherals configuration
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware = {
    opengl.enable = true;
    nvidia = {
        modesetting.enable = true; # required

        powerManagement = {
            enable = true; # Enable this if you have graphical corruption issues waking up from sleep
            finegrained = false; # Turn off GPU when not in use. "Turing" or newer. Can't use this, because we don't have integrated graphix
        };
        
        open = false; # Open-source module (not nouveau, the upstream NVIDIA one...)

        nvidiaSettings = true; # nvidia-settings manager
        
        package = config.boot.kernelPackages.nvidiaPackages.stable; # One of stable, beta, production or vulkan_stable
    };
    pulseaudio.enable = false;
  };

  networking.hostName = "brahe";
  
  networking.networkmanager.enable = true;
  networking.wireless.iwd.enable = true;
  networking.networkmanager.wifi.backend = "iwd";
  
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  services.xserver.displayManager.gdm.enable = true;
  #services.displayManager.sddm.enable = true;
  services.xserver.windowManager.dwm.enable = true;
  services.xserver.desktopManager.cinnamon.enable = true;

  # kde
  #services.xserver.desktopManager.plasma5.enable = true;
  #services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";
  
  # Set X11 monitor R&R

  services.autorandr.enable = true;
  services.autorandr.profiles."default" = {
    fingerprint = { 
      "HDMI-0" = "00ffffffffffff004c2d5b73000e000101210103808e50780aa833ab5045a5270d4848bdef80714f81c0810081809500a9c0b300d1c008e80030f2705a80b0588a00501d7400001e565e00a0a0a029503020350000000000001a000000fd00184b0f873c000a202020202020000000fc0053414d53554e470a202020202001db02035af05561101f041305142021225d5e5f606566626403125a2f0d5707090707150750570700675400830f0000e2004fe305c3016e030c003000b8442800800102030467d85dc40178800be3060d01e30f01e0e5018b849001000000000000000000000000000000000000000000000000000000000000000000000000000b";
    };

    config."HDMI-0" = {
      enable = true;
      primary = false;
      scale = { x = 0.5; y = 0.5; };
      position = "0x0";
      mode = "3840x2160";
      rate = "60.00";
      dpi = 68;
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
