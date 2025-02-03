# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  outputs,
  userName,
  gitName,
  gitEmail,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example
    outputs.homeManagerModules.obsidian

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
  ];

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
    backupFileExtension = "backup";
  };

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  home.packages = with pkgs; [
    bat
    bash
    fish
    eza
    grc
    gh
    ghostty
    neofetch
    nvd
    nushell
    starship
    tmux
    fzf
    chromium
    (nerdfonts.override {fonts = ["Hack"];})
    yazi
    lazygit
    thefuck
    wezterm
    zoxide
  ];

  fonts.fontconfig.enable = true;

  # Enable home-manager and git
  programs = {
    home-manager.enable = true;
    bash = {
      enable = true;
      enableCompletion = true;
      profileExtra = ''
        if uwsm check may-start; then
	    exec systemd-cat -t uwsm_start uwsm start default
        fi
      '';
    };
    gh = {
      enable = true;
      extensions = with pkgs;[
        gh-dash
	gh-eco
	gh-f
        gh-markdown-preview
      ];
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
	  paginate = "never";
	  editor = "nixCats";
	};
      };
    };
    starship = {
      enable = true;
    };
    fish = {
      enable = true;
      loginShellInit = ''
        starship init fish | source
        thefuck --alias | source
	COMPLETE=fish jj | source
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
