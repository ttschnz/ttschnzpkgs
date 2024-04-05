# This file describes your repository contents.
# It should return a set of nix derivations
# and optionally the special attributes `lib`, `modules` and `overlays`.
# It should NOT import <nixpkgs>. Instead, you should take pkgs as an argument.
# Having pkgs default to <nixpkgs> is fine though, and it lets you use short
# commands such as:
#     nix-build -A mypackage

{ pkgs ? import <nixpkgs> { } }:
let
  p = path: pkgs.callPackage path { };
in
{
  # The `lib`, `modules`, and `overlays` names are special
  lib = import ./lib { inherit pkgs; }; # functions
  modules = import ./modules; # NixOS modules
  overlays = import ./overlays; # nixpkgs overlays

  scrcpy = p ./pkgs/scrcpy;
  torctl = p ./pkgs/torctl;
  xnviewmp = p ./pkgs/xnviewmp;
  # wrapWine = p ./pkgs/wine;
  # ms-office = p ./pkgs/wine/ms-office.nix;
}
