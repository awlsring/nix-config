{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    lazygit = {
      enable = lib.mkEnableOption "enables lazygit";
    };
  };

  config = lib.mkIf config.lazygit.enable {
    programs.lazygit = {
      enable = true;
      package = pkgs.lazygit;
      # settings = ''

      # ''
    };
  };
}
