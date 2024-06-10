{
  config,
  pkgs,
  ...
}: {
  programs.git = {
    enable = true;
    userName = "rawmatth";
    userEmail = "rawmatth@amazon.com";
  };

  programs.zsh.initExtraBeforeCompInit = ''
    fpath+=("${config.home.homeDirectory}/.zsh/completion")
    fpath+=("${config.home.homeDirectory}/.brazil_completion/zsh_completion")
  '';

  home = {
    shellAliases = {
      bre = "brazil-runtime-exec";
      brc = "brazil-recursive-cmd";
      bws = "brazil ws";
      bb = "brazil-build";
      bbr = "brazil-build release";
    };
    sessionPath = [
      "${config.home.homeDirectory}/.toolbox/bin"
    ];
    sessionVariables = {
      BRAZIL_PLATFORM_OVERRIDE =
        if pkgs.stdenv.hostPlatform.isAarch64 then "AL2_aarch64"
        else if pkgs.stdenv.hostPlatform.isx86_64 then "AL2_x86_64"
        else null;
    };
    file.".config/brazil/brazil.prefs" = {
      text = ''
        [cli "bin"]
        java17_home = ${pkgs.jdk17}

        ruby27 = ${pkgs.ruby}
      '';
    };
  };

  home.packages = with pkgs; [
    # java
    jdk17

    # ruby
    ruby
  ];
}
