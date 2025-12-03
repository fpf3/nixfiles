{lib, envVars ? {}}:
let
  customdir = builtins.path { path=./custom; };
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
  
  initContent = ''
    #NIX_AUTO_RUN = "1"
    PATH=$PATH:$HOME/bin
  '';
}
