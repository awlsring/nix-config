{ config, lib, pkgs, ... }: {
  
  options = {
    tools = {
      enable = lib.mkEnableOption "enables tools";
    };
  };

  config = lib.mkIf config.tools.enable {
    programs = {
      bat = {
        enable = true;
        extraPackages = with pkgs.bat-extras; [ batman ];
      };
      git.enable = true;
      gpg.enable = true;
    };

    home.packages = with pkgs; [
      # utils
      bc
      bottom
      ripgrep
      fd
      httpie
      jq
      awscli2
      _1password
      alejandra
      tmux
      sops

      # kubernetes
      kubectl
      k9s

      # nix utils
      nix-rebuild
    ];
  };
}