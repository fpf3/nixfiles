{ pkgs, ... }:
{
  nix.distributedBuilds = true;
  nix.settings.builders-use-substitutes = true;

  nix.buildMachines = [
    {
      hostName = "newton.local";
      sshUser = "remotebuild";
      sshKey = "/root/.ssh/id_ed25519";
      systems = [
        pkgs.stdenv.hostPlatform.system
        "i686-linux" # enable lib32 remote builds
      ];
      supportedFeatures = [ "nixos-test" "big-parallel" "kvm" ];
    }
  ];
}
