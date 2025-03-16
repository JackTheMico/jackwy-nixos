{moduleNameSpace, ...}: {pkgs, config, lib,...}:
with lib;
let
  cfg = config.${moduleNameSpace}.gui;
in {
  options.${moduleNameSpace}.gui = {
    enable = mkEnableOption "GUI Setup";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      discord
      keepassxc
      spotify
    ];
  };
}
