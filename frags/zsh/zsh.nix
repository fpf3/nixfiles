{
  enable = true;
  #antidote.enable = true;
  #antidote.plugins = [ ohmyzsh/ohmyzsh ];
  oh-my-zsh = {
      enable = true;
      theme = "half-life";
  };
  autocd = true;
  initExtra = ''
    #NIX_AUTO_RUN = "1"
    PATH=$PATH:/home/fred/bin
  '';
}
