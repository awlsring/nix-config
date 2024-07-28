{...}: {
  imports = [
    ./caddy
    ./frigate.nix
    ./syncthing.nix
    ./garage.nix
    ./tailscale.nix
    ./jellyfin.nix
  ];
}
