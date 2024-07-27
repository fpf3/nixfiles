final: prev: {
  dwm = {
    version = "fpf3_custom";
    src = builtins.fetchurl {
      url = "https://github.com/fpf3/dwm/archive/refs/heads/master.zip";
    };
  };
}
