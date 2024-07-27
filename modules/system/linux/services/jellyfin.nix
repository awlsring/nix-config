# https://nixos.wiki/wiki/Jellyfin
{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {
    jellyfin = {
      enable = lib.mkEnableOption "enables jellyfin";
      intelTranscoding = lib.mkEnableOption "Enable Intel QuickSync transcoding";
    };
  };

  config = lib.mkIf config.jellyfin.enable {
    services.jellyfin = {
      enable = true;
      openFirewall = true;
    };
    environment.systemPackages = with pkgs; [
      jellyfin
      jellyfin-web
      jellyfin-ffmpeg
    ];

    nixpkgs.config.packageOverrides = pkgs: {
      vaapiIntel = lib.mkIf config.jellyfin.intelTranscoding {
        vaapiIntel = pkgs.vaapiIntel.override {
          enableHybridCodec = true;
        };
      };
    };

    hardware.graphics = lib.mkIf config.jellyfin.intelTranscoding {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver
        intel-vaapi-driver # previously vaapiIntel
        vaapiVdpau
        libvdpau-va-gl
        intel-compute-runtime # OpenCL filter support (hardware tonemapping and subtitle burn-in)
        vpl-gpu-rt # QSV on 11th gen or newer
        intel-media-sdk # QSV up to 11th gen
      ];
    };
  };
}
