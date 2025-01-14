{
  inputs,
  lib,
  config,
  pkgs,
  linuxModules,
  modulesPath,
  ...
}: let
  hostname = "dominaria";
in {
  imports = [
    linuxModules.system
    ./disk-configuration.nix
    ./hardware-configuration.nix
  ];

  # Graphics
  hardware.graphics.enable = true;

  # Enable nvidia drivers
  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  boot.loader.grub = {
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  machine = {
    hostname = hostname;
    class = "server";
  };
}
