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
		zfsSupport = true;
		efiSupport = true;
		efiInstallAsRemovable = true;
		mirroredBoots = [
			{ devices = [ "nodev" ]; path = "/boot"; }
		];
	};
  
  fileSystems."/" = {
  	device = "zpool/root";
  	fsType = "zfs";
  	neededForBoot = true;
  };
  
  fileSystems."/home" = {
  	device = "zpool/home";
  	fsType = "zfs";
  };
  
  fileSystems."/boot" = {
  	device = "/dev/disk/by-uuid/5201-0A77";
  	fsType = "vfat";
  };

  swapDevices = [ ];
  

  # Kernel configuration
  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
  boot.kernelParams = [ "nohibernate" ]; # ZFS does not support swapfiles. Ensure we don't try to hibernate.
  #boot.kernelParams = [ "zfs.zfs_arc_max=17179869184" ]; # Set max ARC size to 16GB
  boot.kernelModules = [ "nvidia_uvm" ]; # modprobes

  services.blueman.enable = true;

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

  networking.hostName = "newton";
  
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.windowManager.dwm.enable = true;

  # Configure keymap in X11
  services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Set X11 monitor R&R
  services.xserver.displayManager.setupCommands = ''
    RIGHT='HDMI-0'
    LEFT='DP-0'
    ${pkgs.xorg.xrandr}/bin/xrandr --output $RIGHT --primary --mode 1920x1080 --rate 144.00 --pos 256x0 --rotate right --output $LEFT --mode 2560x1440 --pos 0x240 --rotate normal --rate 155.00
  '';

  # Set X11 monitor R&R

  services.autorandr.enable = true;
  services.autorandr.profiles."default" = {
    fingerprint = { 
      "HDMI-0" = "<EDID>";
      "DP-0" = "<EDID>";
    };

    config."HDMI-0" = {
      enable = true;
      primary = true;
      position = "0x240";
      mode = "2560x1440";
      rate = "155.00";
    };

    config."DP-0" = {
      enable = true;
      primary = false;
      position = "256x0";
      mode = "1920x1080";
      rotate = "right";
      rate = "144.00";
    };
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };
  
  # enable auto-upgrade on reboot
  system.autoUpgrade.enable = true;
  
  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 22 8000 24800 ];
  
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
