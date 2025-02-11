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
      };
    };
  };
}


