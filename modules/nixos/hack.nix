{moduleNameSpace, ...}:{pkgs, lib, config, ...}:
with lib;
let
  cfg = config.${moduleNameSpace}.hack;
in {
  options.${moduleNameSpace}.hack = {
    enable = mkEnableOption "System Hacking module";
  };
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      amass
      arjun
      assetfinder
      burpsuite
      dig
      dirb
      ffuf
      httprobe
      gowitness
      katana
      metasploit
      mitmproxy
      nmap
      nuclei
      nuclei-templates
      wpscan
      subfinder
      sqlmap
      postgresql
    ];
    services.postgresql.enable = true;
  };
}
