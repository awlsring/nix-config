{...}: {
  imports = [
    ./caddy
    ./garage.nix
    ./tailscale.nix
    ./jellyfin.nix
  ];
}
