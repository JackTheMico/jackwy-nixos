# My system level fonts settings
{inputs, moduleNameSpace, ...}:{pkgs, lib, config, ...}:with lib;
let
  cfg = config.${moduleNameSpace}.fonts;
in 
{
  options = {
    ${moduleNameSpace}.fonts = {
      enable = mkEnableOption "System fonts module";
    };
  };

  config = mkIf cfg.enable {
    fonts.packages = with pkgs; [
      # Possible system defaut fonts
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      (nerdfonts.override {fonts = ["Hack" "FiraCode"];})
      maple-mono-NF
    ];
  };
}
