# yoinked from https://github.com/jdheyburn/nixos-configs/blob/b3d8d89f57a5fe079aa60326694edabded0d8979/modules/caddy/custom-caddy.nix
{
  pkgs,
  config,
  plugins,
  stdenv,
  lib,
  ...
}:
stdenv.mkDerivation rec {
  pname = "caddy";
  # https://github.com/NixOS/nixpkgs/issues/113520
  version = "2.7.6";
  dontUnpack = true;

  nativeBuildInputs = [pkgs.git pkgs.go pkgs.xcaddy];

  configurePhase = ''
    export GOCACHE=$TMPDIR/go-cache
    export GOPATH="$TMPDIR/go"
  '';

  buildPhase = let
    pluginArgs =
      lib.concatMapStringsSep " " (plugin: "--with ${plugin}") plugins;
  in ''
    runHook preBuild
    ${pkgs.xcaddy}/bin/xcaddy build "v${version}" ${pluginArgs}
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    mv caddy $out/bin
    runHook postInstall
  '';
}
