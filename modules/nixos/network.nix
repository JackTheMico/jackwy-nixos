{moduleNameSpace, ...}:{pkgs, lib, config, ...}:
with lib;
let
  cfg = config.${moduleNameSpace}.network;
in 
{
  options.${moduleNameSpace}.network = {
    enable = mkEnableOption "System network tools";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      networkmanagerapplet
    ];
  };
}
