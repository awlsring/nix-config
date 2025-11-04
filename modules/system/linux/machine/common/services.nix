{ pkgs, ... }:

{
  # Base power-management policy for desktops/laptops.
  services.upower.enable = true;
  services.logind = {
    lidSwitch = "suspend";
    lidSwitchDocked = "suspend";
    powerKey = "suspend";
    idleAction = "suspend";
    idleActionSec = 1800;
  };
  # Provide GTK/GNOME configuration backends through D-Bus.
  programs.dconf.enable = true;
  services.dbus = {
    enable = true;
    implementation = "broker";
    packages = with pkgs; [
      xfce.xfconf
      gnome2.GConf
    ];
  };
  # Enable core desktop daemons and utilities.
  services.mpd.enable = true;
  programs.thunar.enable = true;
  programs.xfconf.enable = true;
  services.tumbler.enable = true; 
  services.fwupd.enable = true;

  environment.systemPackages = with pkgs; [
    qutebrowser
    zathura
    mpv
    imv
    at-spi2-atk
    qt6.qtwayland
    psi-notify
    poweralertd
    playerctl
    psmisc
    grim
    slurp
    imagemagick
    swappy
    ffmpeg_6-full
    wl-screenrec
    wl-clipboard
    wl-clip-persist
    cliphist
    xdg-utils
    wtype
    wlrctl
    waybar
    rofi
    dunst
    avizo
    wlogout
    gifsicle
  ];
}
