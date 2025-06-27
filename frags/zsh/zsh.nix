{lib, envVars ? {}}:
let
  customdir = builtins.path { path=./custom; };
  old_init = builtins.substring 0 5 (lib.version) <= "24.11"; # XXX remove once everything is off 24.11
in
{
  enable = true;
  oh-my-zsh = {
    enable = true;
    custom = "${customdir}";
    theme = "fpf3-half-life";
  };
  autocd = true;
  sessionVariables = lib.mkIf(envVars != {}) envVars;
}
// lib.optionalAttrs (old_init) {
initExtra = lib.mkIf(old_init) ''
  #NIX_AUTO_RUN = "1"
  PATH=$PATH:$HOME/bin
'';
}
// lib.optionalAttrs(!old_init) {
  initContent = lib.mkIf(!old_init) ''
    #NIX_AUTO_RUN = "1"
    PATH=$PATH:$HOME/bin
  '';
}
