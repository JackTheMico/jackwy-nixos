{moduleNameSpace, ...}: {pkgs, config, lib,...}:
with lib;
let
  cfg = config.${moduleNameSpace}.obsidian;
in {
  options.${moduleNameSpace}.obsidian = {
    enable = mkEnableOption "User Obsidian";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [obsidian];
  };
}
