# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # User-defined system-specific config
      ./newton.nix
      # User-specific config
      ./fred.nix
    ];
  
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # ZFS wants this set. Why? XXX
  networking.hostId = "b2c73136"; # just a random number...

  # Set your time zone.
  time.timeZone = "America/New_York";

  # List packages installed in system profile.
   environment.systemPackages = with pkgs; [
     wget
   ];

  # Enable the OpenSSH daemon.
  services.openssh = {
      enable = true; # We can just leave passwd auth on for the desktop.
  };

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
}

