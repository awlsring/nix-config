# Nix Rebuild
# ------------
# Rebuilds the system configuration with the given hostname and flake location. Works on both NixOS and Nix-Darwin.

# Default values
hostname=$HOST
flake_location=~/nix-config

# Parse named flags
while getopts ":h:f:" opt; do
  case ${opt} in
    h)
      hostname=$OPTARG
      ;;
    f)
      flake_location=$OPTARG
      ;;
    \?)
      echo "Invalid option: -$OPTARG" 1>&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." 1>&2
      exit 1
      ;;
  esac
done

target="${flake_location}#${hostname}"

if [[ "$OSTYPE" == "darwin"* ]]; then
  echo "Rebuilding for nix-darwin"
  darwin-rebuild switch --flake $target
else
  nixos-rebuild switch --flake $target
fi