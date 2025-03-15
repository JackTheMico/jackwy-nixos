{ moduleNameSpace, ... }:
{ config, lib, inputs, ... }:
with lib;
let cfg = config.${moduleNameSpace}.rofi;
  themeDir = "${config.home.homeDirectory}/.config/rofi";
in {
  options.${moduleNameSpace}.rofi = { enable = mkEnableOption "User Rofi"; };

  config = mkIf cfg.enable { 
    xdg.configFile."rofi/themes".source = "${inputs.catppuccin-rofi}/themes";
    xdg.configFile."rofi/catppuccin-default.rasi".source = "${inputs.catppuccin-rofi}/catppuccin-default.rasi";
    programs.rofi = { 
      enable = true; 
      extraConfig = {
        modi= "drun,run,window";
        icon-theme= "Oranchelo";
        show-icons= true;
        terminal= "kitty";
        drun-display-format= "{icon} {name}";
        location= 0;
        disable-history= false;
        hide-scrollbar= true;
        display-drun= "   Apps ";
        display-run= "   Run ";
        display-window= " 󰕰  Window";
        display-Network= " 󰤨  Network";
        sidebar-mode= true;
      };
      theme = "${themeDir}/catppuccin-default.rasi";
    }; 
  };
}
