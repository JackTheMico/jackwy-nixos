{moduleNameSpace, ...}: {pkgs, config, lib,...}:
with lib;
let
  cfg = config.${moduleNameSpace}.hack;
in {
  options.${moduleNameSpace}.hack = {
    enable = mkEnableOption "User Hack";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [metasploit];
  };
}
