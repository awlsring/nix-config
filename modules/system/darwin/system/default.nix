{
  config,
  lib,
  pkgs,
  ...
}: {
  options.system = {
    enable = lib.mkEnableOption "Enables the system module";
    username = lib.mkOption {
      type = lib.types.str;
      default = "awlsring";
      description = "The username of the user";
    };
  };

  config = lib.mkIf config.system.enable {
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

    users.users.${config.system.username} = {
      createHome = true;
      description = "Matthew Rawlings";
      home = "/Users/${config.system.username}";
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
        enableKeyMapping = true;
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
  };
}
