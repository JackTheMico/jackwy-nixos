{moduleNameSpace, ...}: {
  pkgs,
  config,
  lib,
  inputs,
  gitName,
  gitEmail,
  ...
}:
with lib; let
  cfg = config.${moduleNameSpace}.cmdline;
in {
  options.${moduleNameSpace}.cmdline = {
    enable = mkEnableOption "CMDLine Setup";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs;
      [
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
        gtrash
        ghostty
        lazygit
        jq # JSON preview in yazi
        jupyter
        rich-cli # yazi rich-preview requires
        navi # Great cmd help tool
        nix-search-cli
        nvd # Nix/NixOS package version diff tool
        nushell
        neovide
        starship
        translate-shell
        thefuck
        pipx
        zoxide
        zip
        unzip
      ]
      ++ [pkgs.unstable.yazi pkgs.unstable.devenv pkgs.unstable.lazyjournal];
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
      btop = {
        enable = true;
        settings = {
          color_theme = "dracula";
          theme_background = true;
          truecolor = true;
          vim_keys = true;
          rounded_corners = true;
          proc_tree = false;
          log_level = "WARNING";
        };
      };
      navi = {
        enable = true;
        enableBashIntegration = true;
        enableFishIntegration = true;
      };
      git = {
        enable = true;
        userName = gitName;
        userEmail = gitEmail;
        extraConfig = {
          http.proxy = "http://127.0.0.1:7897";
          https.proxy = "http://127.0.0.1:7897";
          commit.gpgsign = true;
          user.signingkey = "A30DF874D95E6029";
        };
      };
      jujutsu = {
        enable = true;
        settings = {
          user = {
            name = gitName;
            email = gitEmail;
          };
          ui = {
            pager = "delta";
            editor = "vim";
            default-command = "log";
            diff.format = "git";
            allow-init-native = true;
          };
        };
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
          transe = "trans -x 127.0.0.1:7897 en:zh ";
          transz = "trans -x 127.0.0.1:7897 zh:en ";
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
          ns = "nix-search";
        };
      };
      # NOTE: Commands needs to be run manually
      # ya pack -a DreamMaoMao/searchjump AnirudhG07/rich-preview Rolv-Apneseth/starship yazi-rs/plugins:full-border
      # ya pack -a ndtoan96/ouch
      yazi = {
        package = pkgs.unstable.yazi;
        enable = true;
        enableBashIntegration = true;
        enableFishIntegration = true;
        enableNushellIntegration = true;
        flavors = {
          dracula = "${inputs.yazi-flavors}/dracula.yazi";
          catppuccin-latte = "${inputs.yazi-flavors}/catppuccin-latte.yazi";
        };
        initLua = ./yaziInit.lua;
        keymap = {
          manager.prepend_keymap = [
            {
              run = "plugin searchjump -- autocd";
              on = ["i"];
              desc = "Searchjump mode";
            }
            {
              run = "plugin ouch --args=zip";
              on = ["C"];
              desc = "Compress with ouch";
            }
          ];
        };
        settings = {
          plugin = {
            prepend_previewers = [
              # Archive previewer
              {
                mime = "application/*zip";
                run = "ouch";
              }
              {
                mime = "application/x-tar";
                run = "ouch";
              }
              {
                mime = "application/x-bzip2";
                run = "ouch";
              }
              {
                mime = "application/x-7z-compressed";
                run = "ouch";
              }
              {
                mime = "application/x-rar";
                run = "ouch";
              }
              {
                mime = "application/x-xz";
                run = "ouch";
              }
              {
                name = "*.csv";
                run = "rich-preview";
              } # for csv files
              {
                name = "*.md";
                run = "rich-preview";
              } # for markdown (.md) files
              {
                name = "*.rst";
                run = "rich-preview";
              } # for restructured text (.rst) files
              {
                name = "*.ipynb";
                run = "rich-preview";
              } # for jupyter notebooks (.ipynb)
              {
                name = "*.json";
                run = "rich-preview";
              } # for json (.json) files
            ];
          };
        };
        theme = {
          flavor = {
            light = "catppuccin-latte";
            dark = "dracula";
          };
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
