{moduleNameSpace, ...}: {
  pkgs,
  config,
  lib,
  inputs,
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
      devenv
      fzf
      fish
      fastfetch
      eza
      grc # I forget what this for.
      gh
      ghostty
      lazygit
      jq # JSON preview in yazi
      navi # Great cmd help tool
      nvd # Nix/NixOS package version diff tool
      nushell
      neovide
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
      navi = {
        enable = true;
        enableBashIntegration = true;
        enableFishIntegration = true;
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
          gitjackinit = ''
            git config commit.gpgsign true
            git config user.email "dlwxxxdlw@gmail.com"
            git config user.name "Jack Wenyoung"
            git config user.signKey "A30DF874D95E6029"
          '';
          y = ''
            function y
            	set tmp (mktemp -t "yazi-cwd.XXXXXX")
            	yazi $argv --cwd-file="$tmp"
            	if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
            		builtin cd -- "$cwd"
            	end
            	rm -f -- "$tmp"
            end
          '';
        };
        plugins = [
          {
            name = "done";
            inherit (pkgs.fishPlugins.done) src;
          }
          {
            name = "grc";
            inherit (pkgs.fishPlugins.grc) src;
          }
          {
            name = "fzf-fish";
            inherit (pkgs.fishPlugins.fzf-fish) src;
          }
        ];
        shellAbbrs = {
          gco = "git checkout";
          npu = "nix-prefetch-url";
          dnv = "devenv";
          ls = "eza";
          ll = "eza -l";
          la = "eza -l -a";
          lt = "eza -T";
          lg = "lazygit";
          lj = "lazyjj";
          md = "mkdir";
          ff = "fastfetch";
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
        flavors = {
          dracula = "${inputs.yazi-flavors}/dracula.yazi";
          catppuccin-latte = "${inputs.yazi-flavors}/catppuccin-latte.yazi";
        };
        theme = {
          flavors = {
            light = "catppuccin-latte";
            dark = "dracula";
          };
        };
        plugins = {
          searchjump = "${inputs.yazi-plugin-searchjump}";
        };
        initLua = ./yaziInit.lua;
        keymap = {
          manager.prepend_keymap = [
            {
              run = "plugin searchjump -- autocd";
              on = ["i"];
            }
          ];
        };
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
