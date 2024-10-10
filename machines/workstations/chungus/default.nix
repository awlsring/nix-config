# Breakout all of this at somepoint
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  home-manager,
  nixosModules,
  ...
}: let
  username = "awlsring";
  hostname = "chungus";
in {
  imports = [
    ../../../modules/system
    ./hardware-configuration.nix
    home-manager.nixosModules.home-manager
  ];

  # machine config
  machine = {
    username = username;
    hostname = hostname;
  };

  # deployment
  services.comin = {
    enable = true;
    hostname = hostname;
    remotes = [
      {
        name = "origin";
        url = "https://github.com/awlsring/nix-config.git";
        branches.main.name = "main";
      }
    ];
  };

  # TODO: move these
  environment.systemPackages = with pkgs; [
    git
    mangohud
    protonup
  ];

  networking.networkmanager.enable = true;
  stylixed = {
    enable = true;
    wallpaper = wallpapers.shaded_landscape;
  };
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  users.users = {
    ${username} = {
      home = "/home/${username}";
      shell = pkgs.zsh;
      createHome = true;
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDKBk8jY0K2Vnr2Jcobao0aoYGAyRzUhDbAEjU1JLq47/Azmy/rDOMaX2EEineisEY4gwrDRt2RF2jeb+/bb2oG0LbqypXiWdXHp6FZcQS9ZV9Udurew2WotP7UtTx+VhOoO1Kc2stw1Qw7GFmMNO8FvSotGh+iD/gNvZKTDXNZDK2rNoyvRpij/lNFseF/ir+Pu3DIToAQMGiFi4ApfFGHk68nkpfR8UikI9C0uWkcQwVO4aTOJXRImAitASZ/otmaOfstE79KBNNL7OiIa2nHwvkA8Z7UW8i34WZsY/AG6lZUvX+0ACaCThQgy73YRy3GC1cV4wvCnxA+BtxvYw982WsEvcSv72E/11ii8hq7czlRb4Y9WnnxfG4IB9NesHqsolvHR3nS6KocHMX/Asa6Q09XD0AQYDQiX/7bOq2oSdA5rPjNYNJH5AGowkBZUAglj35u3xx4t3x2CPJza+mBksbejQDCfFL68zh3Occ+AlT1yksqm4xaUgHYU65Aehk="
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOnue0VrH7rYvnJYSpHKTjKw0/Kzkd+YTYvYwzH1hujv awlsring"
      ];
      extraGroups = ["docker" "networkmanager" "wheel" "audio"];
    };
  };

  home-manager = {
    useUserPackages = true;
    extraSpecialArgs = {inherit inputs outputs username nixosModules;};
    users.${username} = import ./home.nix;
  };

  sound.enable = false;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
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

  # Force Wayland for Electron apps
  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
  };

  # Graphics
  hardware.graphics.enable = true;

  # Enable nvidia drivers
  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
  services.udev.packages = with pkgs; [gnome.gnome-settings-daemon];

  programs.zsh.enable = true;

  # Enable steam
  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;
  programs.gamemode.enable = true;

  # Configure environment
  xdg = {
    autostart.enable = true;
    portal = {
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal
        pkgs.xdg-desktop-portal-gtk
      ];
    };
  };
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
  services.xserver.displayManager = {
    gdm = {
      enable = true;
      wayland = true;
    };
  };
  services.xserver.xkb = {
    layout = "us";
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
