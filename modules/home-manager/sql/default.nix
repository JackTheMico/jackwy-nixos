{moduleNameSpace, ...}: {pkgs, config, lib,...}:
with lib;
let
  cfg = config.${moduleNameSpace}.sql;
in {
  options.${moduleNameSpace}.sql = {
    enable = mkEnableOption "User SQL";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ harlequin mycli pgcli python312Packages.keyring ];
  };
}
