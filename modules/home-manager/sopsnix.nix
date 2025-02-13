{moduleNameSpace, ...}: {inputs, config, lib,...}:
with lib;
let
  cfg = config.${moduleNameSpace}.sopsnix;
  secretsPath = builtins.toString inputs.jackwy-secrets;
in {
  options.${moduleNameSpace}.sopsnix = {
    enable = mkEnableOption "User Sops.nix";
  };

  config = mkIf cfg.enable {
    sops = {
      age.keyFile = "/home/jackwenyoung/.config/sops/age/keys.txt";
      defaultSopsFile = "${secretsPath}/secrets.yaml";
      secrets = {
        "ssh_host_ed25519_key/private/nixos_jackwy_laptop" = {
          path = "/home/jackwenyoung/.ssh/id_nixos_jackwy_laptop";
        };
        gh_token = {};
      };
      templates = {
        "hosts.yml".content = /* yaml */ ''
          github.com:
            users:
              JackTheMico:
                oauth_token: "${config.sops.placeholder.gh_token}"
            git_protocol: ssh
            oauth_token: "${config.sops.placeholder.gh_token}"
            user: JackTheMico
        '';
      };
    };
  };
}


