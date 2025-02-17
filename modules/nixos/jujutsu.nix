{moduleNameSpace, ...}:{pkgs, lib, config, ...}:
with lib;
let
  cfg = config.${moduleNameSpace}.jujutsu;
in {
  options.${moduleNameSpace}.jujutsu = {
    enable = mkEnableOption "System Jujutsu";
  };
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      jujutsu
      lazyjj
    ];
  };
}
