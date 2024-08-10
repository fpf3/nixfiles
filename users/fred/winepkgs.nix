{pkgs, username, ...}:
let
  pkg_builder = { win_pkg, pkgname, exe, win64 ? true }: 
  pkgs.writeShellScriptBin "${pkgname}" ''
    export WINEPREFIX=/home/fred/.wine_prefs/${pkgname}
    ${pkgs.wineWowPackages.full}/bin/wine64 "${win_pkg}/${exe}"
  '';

in
{
  npp = pkg_builder {
    win_pkg = pkgs.fetchzip { 
      url = "https://github.com/notepad-plus-plus/notepad-plus-plus/releases/download/v8.6.9/npp.8.6.9.portable.x64.zip"; 
      hash = "sha256-G+1j4chxrlujtZV3XrBGzNKeUcAOmzcSKdpA0t6rfn8=";
      stripRoot=false;
    };

    pkgname = "npp";
    exe = "notepad++.exe";
  };
}

