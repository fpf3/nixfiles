{pkgs, ...}:
{
  isNormalUser = true;
  group = "wheel";
  openssh.authorizedKeys.keys = import ./ssh_keys.nix;

  shell = pkgs.zsh;
  #packages = [ pkgs.dwm ];
}
