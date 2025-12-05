{ pkgs, lib }:
[
  (final: prev: {
    brlaser = prev.brlaser.overrideAttrs (oldAttrs: {
      postPatch = ''
      substituteInPlace CMakeLists.txt --replace-fail \
      'cmake_minimum_required(VERSION 3.1)' \
      'cmake_minimum_required(VERSION 4.0)'
      '';
    });
  })
  
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
