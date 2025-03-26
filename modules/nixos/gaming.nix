{moduleNameSpace, ...}: {
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.${moduleNameSpace}.gaming;
in {
  options.${moduleNameSpace}.gaming = {
    enable = mkEnableOption "System Gaming Enable";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      steam
      lutris
      gamescope
      wineWowPackages.waylandFull
    ];
    programs = {
      steam = {
        enable = true;
        gamescopeSession.enable = true;
      };
      gamemode.enable = true;
    };
  };
}
