{moduleNameSpace, ...}: {pkgs, config, lib,...}:
with lib;
let
  cfg = config.${moduleNameSpace}.scrcpy;
in {
  options.${moduleNameSpace}.scrcpy = {
    enable = mkEnableOption "Scrcpy";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      qtscrcpy
      scrcpy
      android-tools
    ];
  };
}
