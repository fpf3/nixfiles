{pkgs, ...}:
{
  isNormalUser = true;
  createHome = true;
  group = "wheel";
  openssh.authorizedKeys.keys = import ./ssh_keys.nix;

  extraGroups = [ "dialout" ];

  shell = pkgs.zsh;
  #packages = [ pkgs.dwm ];
}
