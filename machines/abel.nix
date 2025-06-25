{ config, lib, pkgs, ... }:
{
  imports = 
  [
    # fragments
    ../frags/lightdm/lightdm.nix

    # User-specific config
    (import ../users/fred/fred.nix {pkgs=pkgs; config=config; lib=lib;})
  ];

  # bootloader config
  boot.loader.grub.zfsSupport = true;
  
  swapDevices = [ ];

  # Kernel configuration
  # No kernel packages selected -> LTS Kernel
  boot.kernelParams = [ 
    "nohibernate" # ZFS does not support swapfiles. 
    "zfs.zfs_arc_max=17179869184" # Set max ARC size to 16GB
    "kvm.enable_virt_at_load=0" # keeps KVM available
  ]; 
  boot.initrd.kernelModules = [ "amdgpu" "msr" ];
  #boot.initrd.kernelModules = [ "amdgpu" "g_ether" "libcomposite" ];

  boot.binfmt.emulatedSystems = [ "armv7l-linux" ];

  services.blueman.enable = true;

  # peripherals configuration
  services.xserver.videoDrivers = [ "amdgpu" ];
  
  hardware.graphics.enable = true;
  services.pulseaudio.enable = false;

  networking.hostName = "abel";
  
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  #services.xserver.displayManager.gdm.enable = true;
  services.xserver.windowManager.dwm.enable = true;

  services.fprintd.enable = true;
  #services.fprintd.tod.enable = true;
  #services.fprintd.tod.driver = pkgs.libfprint-2-tod1-goodix;
  #security.pam.services.gdm-fingerprint.fprintAuth = true; # "/etc/pam.d/gdm-fingerprint" is  not created by default
  security.pam.services.login.fprintAuth = false;
  security.pam.services.sudo.fprintAuth = false;
  security.pam.services.su.fprintAuth = false;


  services.fwupd.enable = true;

  # screen tearing fix (?)
  services.xserver.deviceSection = ''Option "TearFree" "true"''; # For amdgpu.

  # Set X11 monitor R&R

  services.autorandr.enable = true;
  services.autorandr.profiles."default" = {
    fingerprint = { 
      "eDP" = "00ffffffffffff0009e5ca0b000000002f200104a51c137803de50a3544c99260f505400000001010101010101010101010101010101115cd01881e02d50302036001dbe1000001aa749d01881e02d50302036001dbe1000001a000000fe00424f452043510a202020202020000000fe004e4531333546424d2d4e34310a0073";
    };

    config."eDP" = {
      enable = true;
      primary = true;
      scale = { x = 0.7; y = 0.7; }; 
      position = "0x0";
      mode = "2256x1504";
      rate = "60.00";
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
  networking.firewall.allowedTCPPorts = [ 22 8000 24800 ];

  # Containers

  networking.nat = {
    enable = true;
    internalInterfaces = ["ve-+"];
    externalInterface = "wlp1s0";
  };

  
  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true; # We can just leave passwd auth on for the desktop.
    settings = {
      PasswordAuthentication = false;
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
