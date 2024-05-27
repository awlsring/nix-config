{
  username,
  config,
  lib,
  pkgs,
  stylix,
  ...
}: {
  imports = [
    ./wm
    ./services
    ./system
    ./apps
    stylix.darwinModules.stylix
    # sops-nix.darwinModules.sops # not officially supported, one a dev branch https://github.com/truelecter/sops-nix/blob/darwin-upstream/modules/darwin/default.nix
  ];

  environment = {
    systemPath = lib.mkBefore [
      "/opt/homebrew/bin"
      "/opt/homebrew/sbin"
    ];
    variables = {
      SHELL = lib.getExe pkgs.zsh;
    };
    postBuild = ''
      ln -sv ${pkgs.path} $out/nixpkgs
    '';
  };

  # secrets
  # sops.defaultSopsFile = ../../../secrets/secrets.yaml;
  # sops.defaultSopsFormat = "yaml";
  # sops.age.keyFile = "/Users/${username}/.config/sops/age/keys.txt";

  homebrew = {
    enable = true;
    onActivation = {
      cleanup = "zap";
      autoUpdate = true;
      upgrade = true;
    };
    brews = ["git"];
  };

  users.users.${username} = {
    createHome = true;
    description = "Matthew Rawlings";
    home = "/Users/${username}";
    isHidden = false;
    shell = pkgs.zsh;
  };

  services = {
    nix-daemon = {
      enable = true;
      logFile = "/var/log/nix-daemon.log";
    };
  };

  system = {
    keyboard = {
      remapCapsLockToControl = true;
    };
    stateVersion = 4;
    defaults.SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true;
    includeUninstaller = false;
    defaults.finder = {
      AppleShowAllExtensions = true;
      ShowPathbar = true;
      FXEnableExtensionChangeWarning = false;
    };
    activationScripts.postUserActivation.text = lib.mkAfter ''
      # apply system configs without reboot
      /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
    '';
  };
}
