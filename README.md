# Nix Configs

## Quick start

### MacOS

#### New Mac

Prereqs
- Nix installed
- Homebrew installed

```
echo 'experimental-features = nix-command flakes' | sudo tee -a /etc/nix/nix.conf
sudo launchctl kickstart -k system/org.nixos.nix-daemon
```

```
sudo nix run nix-darwin/master#darwin-rebuild --extra-experimental-features nix-command --extra-experimental-features flakes -- switch --flake .#<device>
```

#### Existing

```
sudo darwin-rebuild switch --flake .#<device>
```