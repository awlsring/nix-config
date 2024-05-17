{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  nixpkgs = {
    # You can add overlays here
    overlays = [
     outputs.overlays.additions
     outputs.overlays.modifications
     outputs.overlays.unstable-packages
    ];
    # Configure your nixpkgs instance
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    userName = "awlsring";
    userEmail = "contact@matthewrawlings.com";
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
