{moduleNameSpace, ...}: {lib, pkgs, config, ...}:
with lib; 
let
  cfg = config.${moduleNameSpace}.wezterm;
in {
  options.${moduleNameSpace}.wezterm = {
    enable = mkEnableOption "Jackwy WezTerm";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs;[
      wezterm
    ];
    programs.wezterm = {
      enable = true;
      extraConfig = config.lib.file.mkOutOfStoreSymlink ./wezterm.lua;
    };
  };
}
