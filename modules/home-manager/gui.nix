{
  moduleNameSpace,
  inputs,
  ...
}: {
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
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
      zoom-us
    ];
    xdg.configFile."keepassxc/keepass_keyfile".source = "${inputs.jackwy-secrets}/keepass_keyfile";
  };
}
