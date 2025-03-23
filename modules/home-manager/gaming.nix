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
    home.packages = with pkgs; [
      protonup
    ];
    home.sessionVariables = {
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\{HOME}/.steam/root/compatibilitytools.d";
    };
  };
}
