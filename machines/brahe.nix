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

  #services.xserver.displayManager.gdm.enable = true;
  services.displayManager.sddm.enable = true;
  services.xserver.windowManager.dwm.enable = true;
  services.xserver.desktopManager.cinnamon.enable = true;

  # kde
  #services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

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
