{ config, lib, pkgs, ... }:
{
  imports = 
  [
    # Containers for server modules
    ../containers/minecraft_servers.nix
    ../containers/jellyfin.nix
    ../containers/web.nix
    #../containers/mail.nix
    
    # User-specific config
    (import ../users/fred/fred.nix {pkgs=pkgs; config=config; lib=lib; withGui=false;})
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
  
  # Kernel configuration
  # No kernel packages selected -> LTS Kernel
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

  # block persistent freaks
  services.fail2ban.enable = true;
  
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
