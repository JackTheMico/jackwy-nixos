{
  description = "Jack Wenyoung's nixos configuration";

  inputs = {
    # Nixpkgs
    sops-nix.url = "github:Mic92/sops-nix";
    # optional, not necessary for the module
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
    # my secrets
    jackwy-secrets = {
      url = "git+ssh://git@github.com/JackTheMico/jackwy-secrets.git?ref=main&shallow=1";
      flake = false;
    };
    # Catppuccin
    catppuccin-hyprland = {
      url = "github:catppuccin/hyprland";
      flake = false;
    };
    catppuccin-hyprlock = {
      url = "github:catppuccin/hyprlock";
      flake = false;
    };
    catppuccin-waybar = {
      url = "github:catppuccin/waybar";
      flake = false;
    };
    catppuccin-rofi = {
      url = "github:catppuccin/rofi";
      flake = false;
    };
    # my nvf configuration repo
    jackwy-nvf = {
      url = "git+ssh://git@github.com/JackTheMico/jackwy-nvf.git";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # qute-keepassxc for password autofill with keepassxc
    qute-keepassxc = {
      url = "github:ususdei/qute-keepassxc";
      flake = false;
    };

    # nixCats
    # nixCats.url = "github:BirdeeHub/nixCats-nvim";
    # plugins-houdini = {
    #   url = "github:TheBlob42/houdini.nvim";
    #   flake = false;
    # };
    # "plugins-hlargs" = {
    #   url = "github:m-demare/hlargs.nvim";
    #   flake = false;
    # };
    # plugins-lzextras = {
    #   url = "github:BirdeeHub/lzextras";
    #   flake = false;
    # };

    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    # You can access packages and modules from different nixpkgs revs
    # at the same time. Here's an working example:
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    # Also see the 'unstable-packages' overlay at 'overlays/default.nix'.
    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    # nur
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    sops-nix,
    catppuccin-hyprland,
    catppuccin-hyprlock,
    ...
  } @ inputs: let
    inherit (self) outputs;
    # Supported systems for your flake packages, shell, etc.
    systems = [
      "aarch64-linux"
      "i686-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    system = "x86_64-linux";
    userName = "jackwenyoung";
    gitName = "Jack Wenyoung";
    gitEmail = "dlwxxxdlw@gmail.com";
    # This is a function that generates an attribute by calling a function you
    # pass to it, with each system as an argument
    forAllSystems = nixpkgs.lib.genAttrs systems;
  in {
    # Your custom packages
    # Accessible through 'nix build', 'nix shell', etc
    packages =
      forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
    # Formatter for your nix files, available through 'nix fmt'
    # Other options beside 'alejandra' include 'nixpkgs-fmt'
    formatter =
      forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    # Your custom packages and modifications, exported as overlays
    overlays = import ./overlays {inherit inputs;};
    # Reusable nixos modules you might want to export
    # These are usually stuff you would upstream into nixpkgs
    nixosModules = import ./modules/nixos {inherit inputs system;};
    # Reusable home-manager modules you might want to export
    # These are usually stuff you would upstream into home-manager
    homeManagerModules = import ./modules/home-manager {inherit inputs system;};

    # I'm suck at loading everything with Lua because I got used to Lazyvim
    # I found nvf is more suitable to me, I'll just use it since I was laid-off and there's nothing to code now.
    # jackwy-nixCats = import ./modules/nixCats { inherit inputs;};

    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      nixos-jackwy-laptop = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit system inputs outputs userName gitName gitEmail;};
        modules = [
          # > Our main nixos configuration file <
          ./hosts/laptop/configuration.nix
          sops-nix.nixosModules.sops
          home-manager.nixosModules.home-manager
          {
            home-manager.useUserPackages = true;
            home-manager.users.${userName} =
              import ./home-manager/jackwy/nixos-jackwy-laptop.nix;
            home-manager.backupFileExtension = "backup";

            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix
            home-manager.extraSpecialArgs = {
              inherit inputs outputs userName gitName gitEmail;
            };
          }
        ];
      };
      nixos-jackwy-desktop = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit system inputs outputs userName gitName gitEmail;};
        modules = [
          # > Our main nixos configuration file <
          ./hosts/desktop/configuration.nix
          sops-nix.nixosModules.sops
          home-manager.nixosModules.home-manager
          {
            home-manager.useUserPackages = true;
            home-manager.users.${userName} =
              import ./home-manager/jackwy/nixos-jackwy-desktop.nix;
            home-manager.backupFileExtension = "backup";

            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix
            home-manager.extraSpecialArgs = {
              inherit inputs outputs userName gitName gitEmail;
            };
          }
        ];
      };
    };

    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .#your-username@your-hostname'
    homeConfigurations = {
      "${userName}@nixos-jackwy-laptop" = home-manager.lib.homeManagerConfiguration {
        pkgs =
          nixpkgs.legacyPackages.${system}; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = {
          inherit inputs outputs userName gitName gitEmail;
        };
        modules = [
          # > Our main home-manager configuration file <
          ./home-manager/jackwy/nixos-jackwy-laptop.nix
        ];
      };
      "${userName}@nixos-jackwy-desktop" = home-manager.lib.homeManagerConfiguration {
        pkgs =
          nixpkgs.legacyPackages.${system}; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = {
          inherit inputs outputs userName gitName gitEmail;
        };
        modules = [
          # > Our main home-manager configuration file <
          ./home-manager/jackwy/nixos-jackwy-desktop.nix
        ];
      };
    };
  };
}
