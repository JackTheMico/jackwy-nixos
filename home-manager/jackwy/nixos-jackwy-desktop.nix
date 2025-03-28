# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  outputs,
  userName,
  # gitName,
  # gitEmail,
  # lib,
  # config,
  # pkgs,
  ...
}: {
  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      # outputs.overlays.additions
      # outputs.overlays.modifications
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
    outputs.homeManagerModules.gaming
    outputs.homeManagerModules.scrcpy
    outputs.homeManagerModules.redshift

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
  ];
  jackwyHMMods = {
    cmdline.enable = true;
    gui.enable = true;
    gaming.enable = true;
    scrcpy.enable = true;
    gh.enable = true;
    sql.enable = true;
    hack.enable = false;
    rofi.enable = true;
    wezterm.enable = true;
    obsidian.enable = true;
    chromium.enable = true;
    redshift.enable = true;
    hyprland = {
      enable = true;
      autoEnter = false;
      monitor = ["DP-2, 1920x1080@60, 0x0, 1" "DP-3, 2560x1440@60, 1920x0, 1"];
    };
    ssh = {
      enable = true;
      githubIdentityFiles = ["~/.ssh/id_nixos_jackwy_desktop"];
    };
    sopsnix.enable = true;
    qutebrowser.enable = true;
  };
  # jackwyHMMods.ncat = {
  #   enable = true;
  #   packageNames = ["ncat" "tcat"];
  # };

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
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.11";
}
