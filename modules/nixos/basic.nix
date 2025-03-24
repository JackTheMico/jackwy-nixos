{
  moduleNameSpace,
  inputs,
  system,
  ...
}: {
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.${moduleNameSpace}.basic;
in {
  options.${moduleNameSpace}.basic = {
    enable = mkEnableOption "System Basic";
  };
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs;
      [
        age
        asciinema
        asciinema-agg
        brightnessctl
        bash
        clash-verge-rev
        clipse
        cachix
        dunst
        fd
        kitty
        just
        # NOTE: An example for python
        # (python312.withPackages (p:
        #   with p; [
        #     pip
        #     pynacl
        #   ]))
        mpv
        sops
        vscode
        wget
        wl-clipboard
        ripgrep
        ueberzug # image-nvim requires
      ]
      ++ [inputs.jackwy-nvf.packages.${system}.default];
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
