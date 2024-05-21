{ pkgs, nix-darwin, ...}: {
  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  nix = {
    package = pkgs.nix;
    settings = {
      "extra-experimental-features" = [ "nix-command" "flakes" ];
    };
  };

  yabai-de = {
    enable = true;
  };

  networking.hostName = "chad";

  programs = {
    gnupg.agent.enable = true;
    zsh.enable = true;
  };

  fonts.fontDir.enable = true;
  fonts.fonts = with pkgs; [
    atkinson-hyperlegible
    jetbrains-mono
  ];

  system.stateVersion = 4;

  nixpkgs.hostPlatform = "aarch64-darwin";

  users.users.awlsring = {
    name = "awlsring";
    home = "/Users/awlsring";
  };

  homebrew = {
    enable = true;
    casks = [
      "1password"
      "bartender"
      "hammerspoon"
      "obsidian"
      "discord"
      "slack"
      "spotify"
    ];
  };
}