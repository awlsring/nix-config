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
    sessionPath = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "List paths to include";
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

    home.sessionVariables = lib.mkMerge [
      {
        SOPS_AGE_KEY_FILE = "$HOME/.config/sops/age/keys.txt";
        KUBECONFIG = "$HOME/.kube/config";
      }
      config.dev.sessionVariables
    ];
    home.shellAliases = config.dev.shellAliases;
    home.sessionPath = config.dev.sessionPath;

    home.packages = with pkgs;
      [
        go
        python313
        nodejs_22
        rustc
        cargo
        claude-code
        go-mockery
      ]
      ++ config.dev.pkgs;
  };
}
