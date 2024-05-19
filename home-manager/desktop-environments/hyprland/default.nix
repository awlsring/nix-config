{
  inputs,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    cinnamon.nemo-with-extensions # file manager
    yazi # terminal file manager
    qalculate-gtk # calculator
  ];
}
