{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {
    impermanence = {
      enable = lib.mkEnableOption "enables impermanence";
      persistedDirectories = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
        description = "Directories to persist across reboots";
      };
      persistedFiles = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
        description = "Files to persist across reboots";
      };
    };
  };

  config = lib.mkIf config.impermanence.enable {
    # Nuke the system
    boot.initrd.postDeviceCommands = lib.mkAfter ''
      mkdir /btrfs_tmp
      mount /dev/root_vg/root /btrfs_tmp
      if [[ -e /btrfs_tmp/root ]]; then
          mkdir -p /btrfs_tmp/old_roots
          timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
          mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
      fi

      delete_subvolume_recursively() {
          IFS=$'\n'
          for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
              delete_subvolume_recursively "/btrfs_tmp/$i"
          done
          btrfs subvolume delete "$1"
      }

      for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
          delete_subvolume_recursively "$i"
      done

      btrfs subvolume create /btrfs_tmp/root
      umount /btrfs_tmp
    '';

    # Persisted areas
    fileSystems."/persist".neededForBoot = true;
    environment.persistence."/persist/system" = {
      hideMounts = true;
      directories = [
        "/etc/nixos"
        "/var/log"
        "/var/lib/bluetooth"
        "/var/lib/nixos"
        "/var/lib/systemd/coredump"
        "/etc/NetworkManager/system-connections"
        {
          directory = "/var/lib/colord";
          user = "colord";
          group = "colord";
          mode = "u=rwx,g=rx,o=";
        }
        (
          if config.impermanence.persistedDirectories != []
          then lib.mkIf config.impermanence.persistedDirectories
          else []
        )
      ];
      files = [
        "/etc/machine-id"
        {
          file = "/var/keys/secret_file";
          parentDirectory = {mode = "u=rwx,g=,o=";};
        }
        (
          if config.impermanence.persistedFiles != []
          then lib.mkIf config.impermanence.persistedFiles
          else []
        )
      ];
    };
  };
}
