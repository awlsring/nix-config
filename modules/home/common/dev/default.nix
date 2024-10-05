{
  config,
  lib,
  pkgs,
  username,
  ...
}: {
  options.dev = {
    email = lib.mkOption {
      type = lib.types.str;
      default = "contact@matthewrawlings.com";
      description = "The email of the user";
    };
    shellAliases = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = {};
      description = "Shell aliases to add";
    };
    sessionVariables = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = {};
      description = "Session variables to add";
    };
    pkgs = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [];
      description = "List of extra tools to install";
    };
  };

  config = {
    programs.git = {
      enable = true;
      userName = username;
      userEmail = config.dev.email;
    };

    home.sessionVariables = config.dev.sessionVariables;
    home.shellAliases = config.dev.shellAliases;

    home.packages = with pkgs;
      [
        go_1_23
        python313
        nodejs_22
        rustc
        cargo
      ]
      ++ config.dev.pkgs;
  };
}
