{ lib
, stdenv
, fetchFromGitHub
, fontconfig
, harfbuzz
, libX11
, libXext
, libXft
, ncurses
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "fpf3-st";
  version = "0.8.4";

  src = fetchGit {
    url = "https://github.com/fpf3/st.git";
    ref = "master";
  };

  nativeBuildInputs = [
    pkg-config
  ];
  buildInputs = [
    fontconfig
    harfbuzz
    libX11
    libXext
    libXft
    ncurses
  ];

  patches = [
    # eliminate useless calls to git inside Makefile
    #./0000-makefile-fix-install.diff
  ];

  installPhase = ''
    runHook preInstall

    TERMINFO=$out/share/terminfo make install PREFIX=$out

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/LukeSmithxyz/st";
    description = "Luke Smith's fork of st";
    license = licenses.mit;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.linux;
  };
}
