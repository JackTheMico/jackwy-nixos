{moduleNameSpace, ...}: {
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.${moduleNameSpace}.gui;
  pinnedZoomPkgs =
    import (builtins.fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/0c19708cf035f50d28eb4b2b8e7a79d4dc52f6bb.tar.gz";
      sha256 = "0ngw2shvl24swam5pzhcs9hvbwrgzsbcdlhpvzqc7nfk8lc28sp3";
    }) {
      system = "x86_64-linux";
      config.allowUnfree = true;
    };
in {
  options.${moduleNameSpace}.gui = {
    enable = mkEnableOption "User GUI Enable";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs;
      [
        discord
        freetube
        keepassxc
        spotify
        qq
        wechat-uos
        # zoom-us
      ]
      ++ [pinnedZoomPkgs.zoom-us];
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
    # xdg.portal = {
    #   extraPortals = with pkgs; [
    #     xdg-desktop-portal-hyprland
    #   ];
    #   config.hyprland = {
    #     "org.freedesktop.impl.portal.ScreenCast" = "hyprland";
    #   };
    # };
    # xdg.configFile."zoomus.conf".text = ''
    #   enableWaylandShare=true
    #   xwayland=true
    # '';
  };
}
