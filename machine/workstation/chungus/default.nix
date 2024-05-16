# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other NixOS modules here
  imports = [
    
    inputs.vscode-server.nixosModules.default
    ./hardware-configuration.nix
    ../../common/sops.nix
  ];

  environment.systemPackages = [ pkgs.git ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  nix = let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Opinionated: disable global registry
      flake-registry = "";
    };
    # Opinionated: disable channels
    channel.enable = false;

    # Opinionated: make flake registry and nix path match flake inputs
    registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };

  # tailscale.enable = true;
  services.vscode-server.enable = true;

  networking.hostName = "chungus";
  networking.networkmanager.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  users.users = {
    awlsring = {
      home = "/home/awlsring";
      createHome = true;
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDKBk8jY0K2Vnr2Jcobao0aoYGAyRzUhDbAEjU1JLq47/Azmy/rDOMaX2EEineisEY4gwrDRt2RF2jeb+/bb2oG0LbqypXiWdXHp6FZcQS9ZV9Udurew2WotP7UtTx+VhOoO1Kc2stw1Qw7GFmMNO8FvSotGh+iD/gNvZKTDXNZDK2rNoyvRpij/lNFseF/ir+Pu3DIToAQMGiFi4ApfFGHk68nkpfR8UikI9C0uWkcQwVO4aTOJXRImAitASZ/otmaOfstE79KBNNL7OiIa2nHwvkA8Z7UW8i34WZsY/AG6lZUvX+0ACaCThQgy73YRy3GC1cV4wvCnxA+BtxvYw982WsEvcSv72E/11ii8hq7czlRb4Y9WnnxfG4IB9NesHqsolvHR3nS6KocHMX/Asa6Q09XD0AQYDQiX/7bOq2oSdA5rPjNYNJH5AGowkBZUAglj35u3xx4t3x2CPJza+mBksbejQDCfFL68zh3Occ+AlT1yksqm4xaUgHYU65Aehk="
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOnue0VrH7rYvnJYSpHKTjKw0/Kzkd+YTYvYwzH1hujv awlsring"
      ];
      extraGroups = ["docker" "networkmanager" "wheel"];
      packages = with pkgs; [
        # firefox
        # vscode
        # git
      #  thunderbird
      ];
    };
  };

  # from config

  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.displayManager.gdm.autoSuspend = false;

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "workman";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";
}
