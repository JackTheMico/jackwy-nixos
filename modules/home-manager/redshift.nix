{moduleNameSpace, ...}: {
  # pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.${moduleNameSpace}.redshift;
in {
  options.${moduleNameSpace}.redshift = {
    enable = mkEnableOption "User Redshift Enable";
  };

  config = mkIf cfg.enable {
    services.redshift = {
      enable = true;
      tray = true;
      provider = "manual";
      temperature = {
        day = 5500;
        night = 3700;
      };
      latitude = 31.770300;
      longitude = 119.944298;
    };
  };
}
