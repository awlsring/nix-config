{
  config,
  lib,
  ...
}: {
  imports = [
    ./common
    ./laptop
    ./desktop
  ];

  config = {
    system.stateVersion = "25.05";
  };
}
