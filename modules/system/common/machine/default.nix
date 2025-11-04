{
  config,
  lib,
  pkgs,
  ...
}: {
  options.machine = {
    username = lib.mkOption {
      type = lib.types.str;
      description = "The username of the user";
    };
    hostname = lib.mkOption {
      type = lib.types.str;
      description = "The hostname of the system";
    };
    class = lib.mkOption {
      type = lib.types.enum ["desktop" "laptop"];
      default = "desktop";
      description = "The class of the machine";
    };
  };

  config = {
    networking.hostName = config.machine.hostname;
  };
}
