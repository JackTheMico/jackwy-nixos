{moduleNameSpace, ...}:{pkgs, lib, config, ...}:
with lib;
let
  cfg = config.${moduleNameSpace}.vcs;
in {
  options.${moduleNameSpace}.vcs = {
    enable = mkEnableOption "System Jujutsu";
  };
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      jujutsu
      lazyjj
      git
    ];
  };
}
