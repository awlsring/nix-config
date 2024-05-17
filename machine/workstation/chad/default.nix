{ pkgs, nix-darwin, ...}:
{
  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  nix = {
    package = pkgs.nix;
    settings = {
      "extra-experimental-features" = [ "nix-command" "flakes" ];
    };
  };

  services.yabai.enable = true;
  services.yabai.package = pkgs.yabai;

  programs = {
    gnupg.agent.enable = true;
    zsh.enable = true;
  };

  fonts.fontDir.enable = true;
  fonts.fonts = [
    pkgs.atkinson-hyperlegible
    pkgs.jetbrains-mono
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
      "firefox"
      "hammerspoon"
      "obsidian"
      "discord"
      "slack"
      "spotify"
    ];
  };

  system.defaults = {
    dock = {
      autohide = true;
      orientation = "left";
      show-process-indicators = false;
      show-recents = false;
      static-only = true;
    };
    finder = {
      AppleShowAllExtensions = true;
      ShowPathbar = true;
      FXEnableExtensionChangeWarning = false;
    };
    NSGlobalDomain = {
      AppleKeyboardUIMode = 3;
      "com.apple.keyboard.fnState" = true;
      NSAutomaticWindowAnimationsEnabled = false;
    };
  };
}