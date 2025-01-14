{
  inputs,
  lib,
  config,
  pkgs,
  linuxModules,
  modulesPath,
  ...
}: let
  hostname = "conflux";
in {
  imports = [
    linuxModules.system
    ./disk-configuration.nix
    ./hardware-configuration.nix
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  boot.loader.grub = {
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  machine = {
    hostname = hostname;
    class = "server";
  };

  tailscale.enable = true;

  # deployment
  services.comin = {
    enable = true;
    hostname = hostname;
    exporter.openFirewall = true;
    remotes = [
      {
        name = "origin";
        url = "https://github.com/awlsring/nix-config.git";
        branches.main.name = "main";
      }
    ];
  };
}
