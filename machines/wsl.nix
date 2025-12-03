{ config, lib, pkgs, ... }:
{

  imports = [
      #../containers/git.nix
      # include NixOS-WSL modules
      <nixos-wsl/modules>
      # User-specific config
      (import ../users/ffrey/ffrey.nix {pkgs=pkgs; config=config; lib=lib;})
    ];

  # allow armv7l binfmt qemu
  boot.binfmt.emulatedSystems = [ "armv7l-linux" ];

  # ZFS wants this set. Why? XXX
  networking.hostId = "b2c73136"; # just a random number...

  # Set your time zone.
  time.timeZone = "America/New_York";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    wget
    xorg.xhost
    kmod
  ];

  environment.sessionVariables = {
  CUDA_PATH = "${pkgs.cudatoolkit}";
  EXTRA_LDFLAGS = "-L/lib -L${pkgs.linuxPackages.nvidia_x11}/lib";
  EXTRA_CCFLAGS = "-I/usr/include";
  LD_LIBRARY_PATH = [
    "/usr/lib/wsl/lib"
    "${pkgs.linuxPackages.nvidia_x11}/lib"
    "${pkgs.ncurses5}/lib"
    "/run/opengl-driver/lib"
  ];
  MESA_D3D12_DEFAULT_ADAPTER_NAME = "Nvidia";
};

  # fonts
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-color-emoji
    #joypixels # figure out how to accept license declaratively
  ];

  virtualisation.waydroid.enable = true;

  swapDevices = [ ];

  wsl = {
    enable = true;
    defaultUser = "ffrey";
    usbip = {
      enable = true;
      snippetIpAddress = "172.20.64.1";
    };


    useWindowsDriver = true;
  };

  hardware.graphics = {
    enable = true;

    extraPackages = with pkgs; [
      mesa
      libvdpau-va-gl
      vaapiVdpau
    ];
  };

  hardware.nvidia = {
  };

  networking.hostName = "wsl";
  
  # Enable the X11 windowing system.
  services.xserver.enable = true;
  
  # enable auto-upgrade on reboot
  system.autoUpgrade.enable = true;
  
  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 22 80 8000 ];

  # big annoyance... .vhd files can't be shrunk easily
  # make sure the store doesn't get too big, we might not be able to deflate.
  nix.optimise = {
    automatic = true;
    dates = [ "19:00" ];
  };

  networking.nat = {
    enable = true;
    internalInterfaces = ["ve-+"];
    externalInterface = "eth0";
  };

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    # require public key auth
    settings = {
      PasswordAuthentication = true;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  # Configure keymap in X11
  services.xserver.xkb.layout = "us";

  # enable avahi
  services.avahi = {
    enable = true;
    
    ipv4 = true;
    nssmdns4 = true;

    ipv6 = false;
    nssmdns6 = false;

    publish = {
      enable = true;
      domain = true;
      addresses = true;
    };

    openFirewall = true;
    domainName = "local";
  };
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
