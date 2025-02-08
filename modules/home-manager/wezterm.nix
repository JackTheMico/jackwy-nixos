{inputs, moduleNameSpace, ...}:{lib, pkgs, config, ...}: 
with lib; 
let
  cfg = config.${moduleNameSpace}.wezterm;
in {
  options.${moduleNameSpace} = {
    enable = mkEnableOption "Jackwy WezTerm";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs;[
      wezterm
    ];
    programs.wezterm = {
      enable = true;
      extraConfig = /*lua*/ ''
      return {
        font = wezterm.font("Maple Mono NF")
	font_size = 18;
	hide_tab_bar_if_only_one_tab = true,
        color_scheme = 'Catppuccin Macchiato'
      }
      '';
    };
  };
}
