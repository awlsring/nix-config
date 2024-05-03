{ config, pkgs, lib, ... }:

let
  scrutiny = pkgs.buildGoModule rec {
    pname = "scrutiny";
    version = "v0.8.1";

    src = pkgs.fetchFromGitHub {
      owner = "AnalogJ";
      repo = pname;
      rev = version;
      sha256 = "5e6ab2290be335076ab4015b5d607a79a06c5be9";
    };

    vendorHas = lib.fakeHash;

    subPackages = ["."];
  };
in
{
  systemd.services.scrutiny = {
    description = "scrutiny metric collector";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${scrutiny}/bin/scrutiny-collector-metrics";
      User = "nobody";
      Group = "nobody";
    };
  };
}