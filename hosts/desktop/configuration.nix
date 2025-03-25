# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  config,
  lib,
  outputs,
  pkgs,
  userName,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    # cachix
    ./cachix.nix
    outputs.nixosModules.network
    outputs.nixosModules.vcs
    outputs.nixosModules.fontProfiles
    outputs.nixosModules.hack
    outputs.nixosModules.basic
    outputs.nixosModules.nutstore
    outputs.nixosModules.gaming
  ];
  jackwySystemMods = {
    fontProfiles.enable = true;
    network.enable = true;
    vcs.enable = true;
    basic.enable = true;
    nutstore.enable = true;
    gaming.enable = true;
    hack.enable = false;
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  networking = {
    hostName = "nixos-jackwy-desktop";
    proxy.default = "http://127.0.0.1:7897";
    proxy.noProxy = "127.0.0.1,localhost,.localdomain";
    wireless = {enable = false;};
    networkmanager = {enable = true;};
  };

  # Set your time zone.
  time.timeZone = "Asia/Shanghai";

  nixpkgs.config.allowUnfree = true;

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
    inputMethod = {
      type = "fcitx5";
      enable = true;
      fcitx5 = {
        waylandFrontend = true;
        addons = with pkgs; [
          fcitx5-chinese-addons
          fcitx5-nord
        ];
      };
    };
  };
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    EDITOR = "vim";
    TERMINAL = "wezterm";
  };
  services = {
    # Enable the X11 windowing system.
    # services.xserver.enable = true;

    # Configure keymap in X11
    # services.xserver.xkb.layout = "us";
    # services.xserver.xkb.options = "eurosign:e,caps:escape";

    # Enable CUPS to print documents.
    # services.printing.enable = true;
    xserver.videoDrivers = ["nvidia"];

    # Enable sound.
    # hardware.pulseaudio.enable = true;
    # OR
    pipewire = {
      enable = true;
      pulse.enable = true;
    };
    blueman.enable = true;

    # List packages installed in system profile. To search, run:
    # $ nix search wget
    # environment.systemPackages = with pkgs; [
    #   vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #   wget
    # ];

    # List services that you want to enable:

    # Enable the OpenSSH daemon.
    openssh.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jackwenyoung = {
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager" "input" "davfs2"]; # Enable ‘sudo’ for the user.
  };
  programs = {
    nh = {
      enable = true;
      flake = "/home/${userName}/codes/jackwy/jackwy-nixos";
      clean = {
        enable = true;
        extraArgs = "--keep 5 --keep-since 3d";
      };
    };
    firefox = {
      enable = true;
      policies = {
        ExtensionSettings = with builtins; let
          extension = shortId: uuid: {
            name = uuid;
            value = {
              install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/${shortId}/latest.xpi";
              installation_mode = "normal_installed";
            };
          };
        in
          listToAttrs [
            (extension "tree-style-tab" "treestyletab@piro.sakura.ne.jp")
            (extension "ublock-origin" "uBlock0@raymondhill.net")
            (extension "umatrix" "uMatrix@raymondhill.net")
            (extension "darkreader" "addon@darkreader.org")
            (extension "immersive-translate" "{5efceaa7-f3a2-4e59-a54b-85319448e305}")
            (extension "keepassxc-browser" "keepassxc-browser@keepassxc.org")
            (extension "zeroomega" "suziwen1@gmail.com")
            (extension "enhancer-for-youtube" "enhancerforyoutube@maximerf.addons.mozilla.org")
          ];
        # To add additional extensions, find it on addons.mozilla.org, find
        # the short ID in the url (like https://addons.mozilla.org/en-US/firefox/addon/!SHORT_ID!/)
        # Then, download the XPI by filling it in to the install_url template, unzip it,
        # run `jq .browser_specific_settings.gecko.id manifest.json` or
        # `jq .applications.gecko.id manifest.json` to get the UUID
      };
    };
    uwsm.enable = true;
    hyprland = {
      enable = true;
      withUWSM = true;
    };
    mtr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };
  nix = {
    settings.experimental-features = ["nix-command" "flakes"];
    optimise.automatic = true;

    # For devenv
    extraOptions = ''
      trusted-users = root jackwenyoung
      extra-substituters = https://devenv.cachix.org
      extra-trusted-public-keys = devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=
    '';
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.11"; # Did you read the comment?
}
