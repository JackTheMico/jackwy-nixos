{moduleNameSpace, ...}: {
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.${moduleNameSpace}.gh;
in {
  options.${moduleNameSpace}.gh = {
    enable = mkEnableOption "User Github Cli";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [gh];
    programs.gh = {
      enable = true;
      settings = {
        aliases = {
          co = "pr checkout";
          pv = "pr view";
        };
        editor = "nvim";
        git_protocol = "ssh";
      };
      extensions = with pkgs; [gh-dash gh-eco gh-f gh-markdown-preview];
    };
  };
}
