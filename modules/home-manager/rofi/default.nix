{ moduleNameSpace, ... }:
{ config, lib, pkgs, ... }:
with lib;
let cfg = config.${moduleNameSpace}.rofi;
in {
  options.${moduleNameSpace}.rofi = { enable = mkEnableOption "User Rofi"; };

  config = mkIf cfg.enable { programs.rofi = { enable = true; }; };
}
