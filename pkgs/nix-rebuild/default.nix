{
  lib,
  stdenv,
  makeWrapper,
  pass,
}:
stdenv.mkDerivation {
  name = "nix-rebuild";
  version = "1.0";
  src = ./nix-rebuild.sh;

  nativeBuildInputs = [makeWrapper];

  dontUnpack = true;
  dontBuild = true;
  dontConfigure = true;

  installPhase = ''
    install -Dm 0755 $src $out/bin/nix-rebuild
  '';

  meta = {
    description = "Runs rebuild for either nixos or nix darwin";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    mainProgram = "nx-rebuild";
  };
}
