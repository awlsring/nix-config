{inputs, ...}: {
  imports = [
    ./monitoring
    ./services
    inputs.stylix.nixosModules.stylix
    inputs.sops-nix.nixosModules.sops
  ];

  fontconfig = {
    defaultFonts = {
      monospace = ["JetBrainsMono Nerd Font Mono"];
      sansSerif = ["JetBrainsMono Nerd Font Mono"];
      serif = ["JetBrainsMono Nerd Font Mono"];
    };
  };
}
