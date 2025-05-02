{lib, envVars ? {}}:
let
  customdir = builtins.path { path=./custom; };
in
{
  enable = true;
  #antidote.enable = true;
  #antidote.plugins = [ ohmyzsh/ohmyzsh ];
  oh-my-zsh = {
    enable = true;
    custom = "${customdir}";
    theme = "fpf3-half-life";
  };
  autocd = true;
  initContent = ''
    #NIX_AUTO_RUN = "1"
    PATH=$PATH:/home/fred/bin
  '';

  sessionVariables = lib.mkIf(envVars != {}) envVars;
}
