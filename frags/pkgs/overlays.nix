{ pkgs, lib }:
[
  (final: prev: {
    autorandr = prev.autorandr.overrideAttrs (oldAttrs: {
      src = pkgs.fetchFromGitHub {
        owner = "fpf3";
        repo = "autorandr";
        rev = "master";
        hash = "sha256-4lRkaR44xtrBmtiLwZYcSG4nA0PCYe+bVb1DN8Oia6o=";
      };
    });
  })
]
