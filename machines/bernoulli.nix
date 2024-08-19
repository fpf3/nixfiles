{ config, lib, pkgs, ... }:
{
  imports = 
  [
    # Containers for server modules
    ./minecraft_servers.nix
    ./jellyfin.nix
  ];

  # bootloader config
  boot.loader.grub = {
		enable = true;
		zfsSupport = true;
		efiSupport = true;
		efiInstallAsRemovable = true;
		#device = "/dev/disk/by-uuid/CC25-5235"; # XXX Why don't this work??
		mirroredBoots = [
			{ devices = [ "nodev" ]; path = "/boot"; }
		];
	};

  fileSystems."/" = {
  	device = "zpool/root";
  	fsType = "zfs";
  	neededForBoot = true;
  };
  
  fileSystems."/var" = {
  	device = "zpool/var";
  	fsType = "zfs";
  };
  
  fileSystems."/nix" = {
  	device = "zpool/nix";
  	fsType = "zfs";
  };
  
  fileSystems."/home" = {
  	device = "zpool/home";
  	fsType = "zfs";
  };
  
  fileSystems."/boot" = {
  	device = "/dev/disk/by-uuid/CC25-5235";
  	fsType = "vfat";
  };
  
  swapDevices = [ ];
  
  # Kernel configuration
  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
  boot.kernelParams = [ "nohibernate" ];

  # mdadm RAID
  boot.swraid.enable = true;
  boot.swraid.mdadmConf = "ARRAY /dev/md/nixos:RAID metadata=1.2 name=nixos:RAID UUID=0e998e37:3a0a40dc:913ac107:8b1055f0";

  networking.hostName = "bernoulli"; # Define your hostname.
  
  # Enable the OpenSSH daemon.
  services.openssh = {
      enable = true;
      # require public key auth
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
      };
  };
  
  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 22 5353 8000 ];

  # Containers

  networking.nat = {
    enable = true;
    internalInterfaces = ["ve-+"];
    externalInterface = "enp4s0";
  };

  system.autoUpgrade = {
    enable = true;
    allowReboot = true;
    rebootWindow = {
        lower = "04:00";
        upper = "05:00";
    };
  };

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?
}
