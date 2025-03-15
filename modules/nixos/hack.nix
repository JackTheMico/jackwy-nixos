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
      # metasploit
      mitmproxy
      nmap
      nuclei
      nuclei-templates
      wpscan
      subfinder
      sqlmap
      # postgresql
    ];
    services.postgresql = {
      enable = true;
      enableTCPIP = true;
      authentication = pkgs.lib.mkOverride 10 ''
        # TYPE  DATABASE  DBuser  ADDRESS       METHOD
          local all       all                   trust
          host  all       all     127.0.0.1/32  trust
          host  all       all     ::1/128       trust
      '';
      ensureUsers = [
        {
          name = "msftest";
          ensureClauses = {
            createdb = true;
          };
        }
        {
          name = "msf";
          ensureClauses = {
            createdb = true;
          };
        }
      ];
      settings = {
        port = 5432;
        log_connections = true;
        log_statement = "all";
        logging_collector = true;
        log_disconnections = true;
        log_destination = lib.mkForce "syslog";
      };
    };
  };
}
