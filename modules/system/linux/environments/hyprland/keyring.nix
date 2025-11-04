{
  config,
  lib,
  pkgs,
  ...
}: let
  hyprlandEnabled = config.environments.hyprland.enable;
  username = config.machine.username or null;
  dataHome =
    if username != null
    then lib.attrByPath ["home-manager" "users" username "xdg" "dataHome"] null config
    else null;
in {
  config = lib.mkIf hyprlandEnabled {
    services.gnome.gnome-keyring.enable = true;
    security.pam.services.login.enableGnomeKeyring = true;
    systemd.user.services.polkit-gnome = {
      wantedBy = [ "graphical-session.target" ];

      unitConfig = {
        Description = "GNOME PolicyKit Agent";
        After = [ "graphical-session.target" ];
        PartOf = [ "graphical-session.target" ];
      };
      serviceConfig = {
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      };
    };
    environment.variables =
      lib.mkIf (dataHome != null) {
        GNUPGHOME = "${dataHome}/.gnupg";
      };
    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    security.pam.services.hyprland = {
      text = ''
        auth optional pam_gnome_keyring.so
        session optional pam_gnome_keyring.so auto_start
      '';
    };
    programs.seahorse.enable = true;
  };
}
