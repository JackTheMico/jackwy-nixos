{moduleNameSpace, ...}: {pkgs, config, lib,...}:
with lib;
let
  cfg = config.${moduleNameSpace}.chromium;
in {
  options.${moduleNameSpace}.chromium = {
    enable = mkEnableOption "User chromium";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      chromium
    ];
    programs.chromium = {
      enable = true;
      extensions = [
        # "chlffgpmiacpedhhbkiomidkjlcfhogd" # pushbullet
        # "mbniclmhobmnbdlbpiphghaielnnpgdp" # lightshot
        "gcbommkclmclpchllfjekcdonpmejbdp" # https everywhere
        "cjpalhdlnbpafiamejdnhcphjbkeiagm" # ublock origin
        "padekgcemlokbadohgkifijomclgjgif" # Proxy Swithyomega
        "dhdgffkkebhmkfjojejmpbldmpobfkfo" # Tampermonkey
        "bpoadfkcbjbfhfodiogcnhhhpibjhbnh" # Immersive Translate
        "eimadpbcbfnmbkopoojfekhnkhdbieeh" # Dark reader
        "gfbliohnnapiefjpjlpjnehglfpaknnc" # Surfingkeys
        "hddnkoipeenegfoeaoibdmnaalmgkpip" # Toby
        "kbfnbcaeplbcioakkpcpgfkobkghlhen" # Grammarly
      ];
    };
  };

}
