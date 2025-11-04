{ pkgs,  ... }:

{
  # Bootloader things
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 2;
  # boot.initrd.enable = true;
  # boot.initrd.verbose = false;
  # boot.initrd.systemd.enable = true;
  # boot.initrd.availableKernelModules = [ "amdgpu" ];
  # boot.initrd.kernelModules          = [ "amdgpu" ];
  # boot.consoleLogLevel = 3;
  # boot.plymouth = {
  #   enable = true;
  #   font = "${pkgs.jetbrains-mono}/share/fonts/truetype/JetBrainsMono-Regular.ttf";
  #   themePackages = [ pkgs.catppuccin-plymouth ];
  #   theme = "catppuccin-macchiato";
  # };
}