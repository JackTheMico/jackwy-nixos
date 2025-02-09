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
    outputs.nixosModules.network
    outputs.nixosModules.jujutsu
    outputs.nixosModules.fontProfiles
  ];

  jackwySystemMods.fontProfiles.enable = true;
  jackwySystemMods.network.enable = true;
  jackwySystemMods.jujutsu.enable = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
  networking = {
    hostName = "nixos-jackwy-laptop";
    proxy.default = "http://127.0.0.1:7897";
    proxy.noProxy = "127.0.0.1,localhost,.localdomain";
    wireless = {
      enable = false;
    };
    networkmanager = {
      enable = true;
    };
  };

  # Set your time zone.
  time.timeZone = "Asia/Shanghai";

  # Allow unfree
  nixpkgs.config.allowUnfree = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
    inputMethod = {
      type = "fcitx5";
      enable = true;
      fcitx5 = {
        waylandFrontend = true;
        addons = with pkgs; [
      	  fcitx5-chinese-addons  # table input method support
      	  fcitx5-nord            # a color theme
      	];
      };
   };
  };
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  # Configure keymap in X11
  services.xserver.xkb.layout = "us";
  services.xserver.xkb.options = "eurosign:e,ctrl:swapcaps";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  # hardware.pulseaudio.enable = true;
  # OR
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jackwenyoung = {
    isNormalUser = true;
    extraGroups = ["wheel"]; # Enable ‘sudo’ for the user.
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    age
    brightnessctl
    clash-verge-rev
    dunst
    swww # wallpaper
    fd
    git
    just
    nautilus
    nautilus-open-any-terminal
    waybar
    wget
    wl-clipboard
    sops
    wofi
    ripgrep
    bash
    kitty
  ];

  programs = {
    clash-verge = {
      enable = true;
      package = pkgs.clash-verge-rev;
      tunMode = true;
      autoStart = true;
    };
    nh = {
      enable = true;
      flake = "/home/${userName}/codes/jackwy/jackwy-nixos";
      clean = {
        enable = true;
        extraArgs = "--keep 5 --keep-since 3d";
      };
    };
    firefox.enable = true;
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
  # Enable Flakes
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Storage Optimization
  nix.optimise.automatic = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # NOTE: https://discourse.nixos.org/t/how-to-automatically-mount-external-hard-drive/15563/2
  # Try to automatically mount external hard drive
  services.devmon.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;

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
