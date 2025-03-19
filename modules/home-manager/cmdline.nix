{moduleNameSpace, ...}: {
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.${moduleNameSpace}.cmdline;
in {
  options.${moduleNameSpace}.cmdline = {
    enable = mkEnableOption "CMDLine Setup";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      bat
      bash
      chezmoi
      delta
      fzf
      fish
      fastfetch
      eza
      grc # I forget what this for.
      gh
      ghostty
      lazygit
      nvd # Nix/NixOS package version diff tool
      nushell
      starship
      yazi
      thefuck
      zoxide
    ];
    programs = {
      bash = {
        enable = true;
        enableCompletion = true;
        # Enter fish shell
        initExtra = ''
          if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
          then
            shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
            exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
          fi
        '';
      };
      kitty = {
        enable = true;
        font.name = "Maple Mono NF";
        themeFile = "Dracula";
        shellIntegration = {
          enableFishIntegration = true;
          enableBashIntegration = true;
        };
        settings = {
          scrollback_lines = 10000;
          enable_audio_bell = true;
          update_check_interval = 0;
        };
      };
      starship = {enable = true;};
      fish = {
        enable = true;
        interactiveShellInit = ''
          starship init fish | source
          thefuck --alias | source
          jj util completion fish | source
          fzf_configure_bindings --processes=\cp
        '';
        functions = {
          enproxy = "set -xg ALL_PROXY http://localhost:7897 ; set -xg HTTP_PROXY http://localhost:7897 ; set -xg HTTPS_PROXY http://localhost:7897; echo 'Proxy Enabled'";
          deproxy = "set -e ALL_PROXY; set -e HTTPS_PROXY; set -e HTTP_PROXY; echo 'Proxy disabled'";
          gitignore = "curl -sL https://www.gitignore.io/api/$argv";
        };
        plugins = [
          {
            name = "done";
            src = pkgs.fishPlugins.done.src;
          }
          {
            name = "grc";
            src = pkgs.fishPlugins.grc.src;
          }
          {
            name = "fzf-fish";
            src = pkgs.fishPlugins.fzf-fish.src;
          }
        ];
        shellAbbrs = {
          gco = "git checkout";
          npu = "nix-prefetch-url";
          ls = "eza";
          ll = "eza -l";
          la = "eza -l -a";
          lt = "eza -T";
          lg = "lazygit";
          lj = "lazyjj";
          md = "mkdir";
          jjbm = "jj bookmark s -r @- main";
          gpom = "git push -u origin main";
          czi = "chezmoi";
        };
      };
      yazi = {
        enable = true;
        enableBashIntegration = true;
        enableFishIntegration = true;
        enableNushellIntegration = true;
      };
      zoxide = {
        enable = true;
        enableBashIntegration = true;
        enableFishIntegration = true;
        enableNushellIntegration = true;
      };
    };
  };
}
