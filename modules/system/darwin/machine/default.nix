{
  config,
  lib,
  pkgs,
  ...
}: {
  config =  {
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

    users.users.${config.machine.username} = {
      createHome = true;
      description = "Matthew Rawlings";
      home = "/Users/${config.machine.username}";
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
