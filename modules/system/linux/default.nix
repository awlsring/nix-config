{inputs, ...}: {
  imports = [
    ./monitoring
    ./services
    inputs.stylix.nixosModules.stylix
    inputs.sops-nix.nixosModules.sops
  ];

  security.sudo.extraRules = [
    {
      users = ["privileged_user"];
      commands = [
        {
          command = "ALL";
          options = ["NOPASSWD"];
        }
      ];
    }
  ];

  # System Fonts
  fonts.fontconfig = {
    defaultFonts = {
      monospace = ["JetBrainsMono Nerd Font Mono"];
      sansSerif = ["JetBrainsMono Nerd Font Mono"];
      serif = ["JetBrainsMono Nerd Font Mono"];
    };
  };
}
