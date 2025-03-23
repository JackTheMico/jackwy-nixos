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
      keepassxc
      spotify
      qq
      wechat-uos
      zoom-us
    ];
  };
}
