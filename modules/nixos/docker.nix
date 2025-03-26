{moduleNameSpace, ...}: {
  pkgs,
  userName,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.${moduleNameSpace}.docker;
in {
  options.${moduleNameSpace}.docker = {
    enable = mkEnableOption "System Docker Enable";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [arion compose2nix lazydocker docker-client];
    virtualisation.docker.enable = false;
    virtualisation.podman = {
      enable = true;
      dockerSocket.enable = true;
      defaultNetwork.settings.dns_enabled = true;
    };
    users.users.${userName}.extraGroups = ["docker" "podman"];
  };
}
