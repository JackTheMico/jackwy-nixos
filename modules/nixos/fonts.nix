# My system level fonts settings
{moduleNameSpace, ...}:{pkgs, lib, config, ...}:
let
  cfg = config.${moduleNameSpace}.fontProfiles;
in {
  options.${moduleNameSpace}.fontProfiles = {
    enable = lib.mkEnableOption "System fonts module";
  };

  config = lib.mkIf cfg.enable {
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
