{moduleNameSpace, ...}:{pkgs, lib, config, ...}:
with lib;
let
  cfg = config.${moduleNameSpace}.basic;
in {
  options.${moduleNameSpace}.basic = {
    enable = mkEnableOption "System Basic";
  };
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      age
      asciinema
      asciinema-agg
      brightnessctl
      clash-verge-rev
      clipse
      cachix
      dunst
      fd
      just
      nautilus
      nautilus-open-any-terminal
      vscode
      wget
      wl-clipboard
      sops
      ripgrep
      bash
      kitty
    ];
    programs = {
      clash-verge = {
        enable = true;
        package = pkgs.clash-verge-rev;
        tunMode = true;
        autoStart = true;
      };
    };
    # Configure keymap in X11
    services.xserver.xkb.layout = "us";
    services.xserver.xkb.options = "eurosign:e,ctrl:nocaps";
  };
}
