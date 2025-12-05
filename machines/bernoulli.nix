{ config, lib, pkgs, ... }:
{
  imports = 
  [
    # fragments
    ../frags/zfs/zfs.nix

    # Containers for server modules
    ../containers/minecraft_servers.nix
    ../containers/ds_experiments.nix
    ../containers/jellyfin.nix
    ../containers/web.nix
    #../containers/mail.nix
    
    # User-specific config
    (import ../users/fred/fred.nix {pkgs=pkgs; config=config; lib=lib; withGui=false;})
  ];
  
  # Kernel configuration
  # No kernel packages selected -> LTS Kernel
  boot.kernelParams = [ 
    "nohibernate" # ZFS does not support swapfiles. 
    "zfs.zfs_arc_max=17179869184" # Set max ARC size to 16GB
    #"kvm.enable_virt_at_load=0" # keeps KVM available (do we want this for real virtualization later?)
  ]; 

  ## mdadm RAID
  #boot.swraid.enable = true;
  #boot.swraid.mdadmConf = "ARRAY /dev/md/nixos:RAID metadata=1.2 name=nixos:RAID UUID=0e998e37:3a0a40dc:913ac107:8b1055f0";

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
  
  home-manager.users.fred.home.packages = with pkgs; [
    nvtopPackages.amd
  ];

  # block persistent freaks
  services.fail2ban.enable = true;
  
  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 22 3389 3390 3391 3392 5353 8000 ];

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
