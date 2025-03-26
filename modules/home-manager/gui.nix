{moduleNameSpace, ...}: {
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.${moduleNameSpace}.gui;
in {
  options.${moduleNameSpace}.gui = {
    enable = mkEnableOption "User GUI Enable";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      discord
      freetube
      keepassxc
      spotify
      qq
      wechat-uos
      zoom-us
    ];
    programs = {
      freetube = {
        enable = true;
        settings = {
          checkForUpdates = false;
          defaultQuality = "1080";
          baseTheme = "catppuccinMocha";
        };
      };
      obs-studio = {
        enable = true;
        plugins = with pkgs.obs-studio-plugins; [wlrobs obs-shaderfilter input-overlay waveform];
      };
    };
  };
}
