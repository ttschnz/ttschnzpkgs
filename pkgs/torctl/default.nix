
{ lib
, stdenv
, fetchurl
, fetchFromGitHub
, pkg-config
, runtimeShell
, installShellFiles
, pkgs ? import <nixpkgs> {} 
}:

let
  version = "0.5.7";
in
stdenv.mkDerivation rec {
  pname = "torctl";
  inherit version;

  src = fetchFromGitHub {
    owner = "BlackArch";
    repo = "torctl";
    rev = "v${version}";
    hash = "sha256-rTJR+9pbK/sWMqdHyIqJgASgCGtGtpUPoHmYZJ7COFQ=";
    };
  buildInputs = [
    pkgs.bash
  ];
  installPhase = ''
    # copy resources
    mkdir -p $out
    cp -r $src/* $out/

    # make a home for the executable
    mkdir -p $out/bin
    ln -s $out/torctl $out/bin/torctl
    chmod +x $out/bin/torctl

    # enable services
    mkdir -p $out/etc/systemd/system
    ln -s $out/service/torctl-autostart.service $out/etc/systemd/system/torctl-autostart.service
    ln -s $out/service/torctl-autowipe.service $out/etc/systemd/system/torctl-autowipe.service
    #systemctl daemon-reload

    # add bash completion ($out/bash_completion/torctl)
    mkdir -p $out/etc/bash_completion.d
    ln -s $out/bash_completion/torctl $out/etc/bash_completion.d/torctl

  '';
  meta = with lib; {
    description = "Script to redirect all traffic through tor network including dns queries for anonymizing entire system";
    homepage = "https://www.blackarch.org/";
    changelog = "https://github.com/Blackarch/troctl/releases/tag/v${version}";
    sourceProvenance = with sourceTypes; [
      fromSource
    ];
    license = licenses.gpl3;
    platforms = platforms.unix;
    mainProgram = "torctl";
  };
}