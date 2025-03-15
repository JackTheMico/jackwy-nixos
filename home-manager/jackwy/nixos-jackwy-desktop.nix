# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{ inputs, outputs, userName, gitName, gitEmail, lib, config, pkgs, ... }: {
  # You can import other home-manager modules here
  imports = [
    # Sops home-manager module
    inputs.sops-nix.homeManagerModules.sops

    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example
    outputs.homeManagerModules.gh
    outputs.homeManagerModules.hyprland
    outputs.homeManagerModules.obsidian
    outputs.homeManagerModules.wezterm
    outputs.homeManagerModules.chromium
    outputs.homeManagerModules.rofi
    outputs.homeManagerModules.ssh
    outputs.homeManagerModules.sopsnix
    outputs.homeManagerModules.qutebrowser
    outputs.homeManagerModules.sql
    outputs.homeManagerModules.hack
    outputs.jackwy-nixCats.homeModules.default

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
  ];
  jackwyHMMods.gh.enable = false;
  jackwyHMMods.sql.enable = true;
  jackwyHMMods.hack.enable = false;
  jackwyHMMods.rofi.enable = true;
  jackwyHMMods.wezterm.enable = true;
  jackwyHMMods.obsidian.enable = true;
  jackwyHMMods.chromium.enable = true;
  jackwyHMMods.hyprland = {
    enable = true;
    autoEnter = false;
  };
  jackwyHMMods.ssh = {
    enable = true;
    githubIdentityFiles = [ "~/.ssh/id_nixos_jackwy_desktop" ];
  };
  jackwyHMMods.sopsnix.enable = false;
  jackwyHMMods.qutebrowser.enable = true;
  jackwyHMMods.ncat = {
    enable = true;
    packageNames = [ "ncat" "tcat" ];
  };

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  # NOTE: Set your username
  home = {
    username = userName;
    homeDirectory = "/home/${userName}";
  };

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  home.packages = with pkgs; [
    bat
    bash
    chezmoi
    discord # Might need to change nixos store source
    delta
    fish
    eza
    grc
    gh
    ghostty
    neovim
    fastfetch
    nvd
    nushell
    starship
    spotify
    fzf
    yazi
    lazygit
    thefuck
    zoxide
  ];

  # Enable home-manager and git
  programs = {
    home-manager.enable = true;
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
    firefox.profiles.${userName}.extensions =
      with pkgs.nur.repos.rycee.firefox-addons; [
        swithyomega
        tampermonkey
        darkreader
        tree-style-tab
        immersive-translate
        #NOTE: Install Toby manually.
      ];
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
      font.name = "Hack";
      settings = {
        scrollback_lines = 10000;
        enable_audio_bell = false;
        update_check_interval = 0;
      };
    };
    starship = { enable = true; };
    fish = {
      enable = true;
      interactiveShellInit = ''
        starship init fish | source
        thefuck --alias | source
        jj util completion fish | source
        fzf_configure_bindings --processes=\cp
      '';
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

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.11";
}
