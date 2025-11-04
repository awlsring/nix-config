{ pkgs, ... }:

{
  # Enable Podman
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    dockerSocket.enable = true;
    defaultNetwork.settings.dns_enabled = true;
  };
  environment.variables.DBX_CONTAINER_MANAGER = "podman";
  users.extraGroups.podman.members = [ "awlsring" ];

  environment.systemPackages = with pkgs; [
    nerdctl
    distrobox
    qemu
    lima
    podman-compose
    podman-tui
    docker-compose
  ];
}