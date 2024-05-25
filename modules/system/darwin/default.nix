{ username, config, lib, pkgs, stylix, ... }: {
  imports = [ 
    ./wm 
    ./services
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
    brews = [ "git" ];
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
    stateVersion = 4;
    defaults.SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true;
    includeUninstaller = false;
    defaults.finder = {
        AppleShowAllExtensions = true;
        ShowPathbar = true;
        FXEnableExtensionChangeWarning = false;
    };
    activationScripts.applications.text = lib.mkForce ''
      echo "setting up ~/Applications..." >&2
      applications="$HOME/Applications"
      nix_apps="$applications/Nix Apps"

      # Needs to be writable by the user so that home-manager can symlink into it
      if ! test -d "$applications"; then
          mkdir -p "$applications"
          chown ${username}: "$applications"
          chmod u+w "$applications"
      fi

      # Delete the directory to remove old links
      rm -rf "$nix_apps"
      mkdir -p "$nix_apps"
      find ${config.system.build.applications}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
          while read src; do
              # Spotlight does not recognize symlinks, it will ignore directory we link to the applications folder.
              # It does understand MacOS aliases though, a unique filesystem feature. Sadly they cannot be created
              # from bash (as far as I know), so we use the oh-so-great Apple Script instead.
              /usr/bin/osascript -e "
                  set fileToAlias to POSIX file \"$src\" 
                  set applicationsFolder to POSIX file \"$nix_apps\"
                  tell application \"Finder\"
                      make alias file to fileToAlias at applicationsFolder
                      # This renames the alias; 'mpv.app alias' -> 'mpv.app'
                      set name of result to \"$(rev <<< "$src" | cut -d'/' -f1 | rev)\"
                  end tell
              " 1>/dev/null
          done
    '';
  };
}