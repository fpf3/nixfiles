{ config, lib, pkgs, ... }:
{
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
  
  swapDevices = [ ];

  # Kernel configuration
  # No kernel packages selected -> LTS Kernel
  boot.kernelParams = [ "nohibernate" ]; # ZFS does not support swapfiles. Ensure we don't try to hibernate.
  #boot.kernelParams = [ "zfs.zfs_arc_max=17179869184" ]; # Set max ARC size to 16GB
  boot.kernelModules = [ "nvidia_uvm" ]; # modprobes

  services.blueman.enable = true;

  # peripherals configuration
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware = {
    graphics.enable = true;
    nvidia = {
        modesetting.enable = true; # required

        powerManagement = {
            enable = true; # Enable this if you have graphical corruption issues waking up from sleep
            finegrained = false; # Turn off GPU when not in use. "Turing" or newer. Can't use this, because we don't have integrated graphix
        };
        
        open = true; # Open-source module (not nouveau, the upstream NVIDIA one...)

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

  services.autorandr.enable = true;
  services.autorandr.profiles."default" = {
    fingerprint = { 
      "DP-0" = "00ffffffffffff0005e33032980a0000221f0104b54627783f6665ac4f47a727125054bfef00d1c081803168317c4568457c6168617c565e00a0a0a0295030203500b9882100001e000000ff005043544d384a41303032373132000000fc0041473332335157473452332b0a000000fd00309be6e63d010a2020202020200106020332f14c0103051404131f120211903f2309070783010000e305e301e60607016363006d1a00000201309b00000000000049ed006aa0a01e5008203500b9882100001a40e7006aa0a0675008209804b9882100001a6fc200a0a0a0555030203500b9882100001ef03c00d051a0355060883a00b9882100001c0000000000f0";
      "HDMI-0" = "00ffffffffffff0006b32024078600001220010380341d782a7145a954519a25135054bfcf00814081809500714f81c0b30001010101023a801871382d40582c450009252100001efc7e8088703812401820350009252100001e000000fd0030901eb422000a202020202020000000fc00415355532056473234560a202001cf02032cf150010304131f120211900e0f1d1e3f1405230907078301000065030c001000681a000001013090e6000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000083";
    };

    config."DP-0" = {
      enable = true;
      primary = true;
      position = "0x240";
      mode = "2560x1440";
      rate = "155.00";
    };

    config."HDMI-0" = {
      enable = true;
      primary = false;
      position = "2560x0";
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
