{pkgs, ...}:
(with pkgs; [
  acpi
  bc
  clang-tools
  fd
  file
  htop
  lm_sensors
  man-pages
  man-pages-posix
  ncdu
  nodejs
  openfortivpn
  pciutils
  (python3.withPackages (ps: with ps; with python3Packages; [
      ipympl
      ipython
      jupyter
      matplotlib
      numpy
      pandas
      scipy
    ]))
  ranger
  ripgrep
  screen
  sshfs
  sysstat
  tmux
  tree
  unzip
  usbutils
  wget
  yubikey-manager
  zsh
])
