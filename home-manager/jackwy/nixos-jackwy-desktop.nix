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
    outputs.homeManagerModules.cmdline
    outputs.homeManagerModules.gui
    outputs.homeManagerModules.scrcpy
    outputs.jackwy-nixCats.homeModules.default

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
  ];
  jackwyHMMods.cmdline.enable = true;
  jackwyHMMods.gui.enable = true;
  jackwyHMMods.scrcpy.enable = true;
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
    monitor = ["DP-2, 1920x1080@60, 0x0, 1" "DP-3, 2560x1440@60, 1920x0, 1"];
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
      # outputs.overlays.additions
      # outputs.overlays.modifications
      # outputs.overlays.unstable-packages

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
  # home.packages = with pkgs; [
  # ];

  # Enable home-manager and git
  programs = {
    home-manager.enable = true;
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
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.11";
}
