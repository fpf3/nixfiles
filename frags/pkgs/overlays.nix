{ pkgs, lib }:
[
  (final: prev: {
    # upstream autorandr has a bug they won't merge my PR :(
    autorandr = prev.autorandr.overrideAttrs (oldAttrs: {
      src = pkgs.fetchFromGitHub {
        owner = "fpf3";
        repo = "autorandr";
        rev = "master";
        hash = "sha256-4lRkaR44xtrBmtiLwZYcSG4nA0PCYe+bVb1DN8Oia6o=";
      };
    });

    # openldap test failures upstream, disable all checks for now
    openldap = prev.openldap.overrideAttrs(oldAttrs: {
      doCheck = !prev.stdenv.hostPlatform.isi686;
    });
  })
]
