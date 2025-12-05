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
]
