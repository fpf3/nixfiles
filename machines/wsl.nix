{ config, lib, pkgs, ... }:
{

  imports = [
      # include NixOS-WSL modules
      <nixos-wsl/modules>
      # User-specific config
      (import ../users/ffrey/ffrey.nix {pkgs=pkgs; config=config; lib=lib})
    ];

  swapDevices = [ ];

  wsl.enable = true;
  wsl.defaultUser = "ffrey";
  wsl.usbip = {
    enable = true;
    autoAttach = [ "3-3" ];
  };

  networking.hostName = "wsl";
  
  networking.networkmanager.enable = true;
  
  # Enable the X11 windowing system.
  services.xserver.enable = true;
  
  # enable auto-upgrade on reboot
  system.autoUpgrade.enable = true;
  
  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 22 8000 ];

  # big annoyance... .vhd files can't be shrunk easily
  # make sure the store doesn't get too big, we might not be able to deflate.
  nix.optimise = {
    automatic = true;
    dates = [ "19:00" ];
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

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
