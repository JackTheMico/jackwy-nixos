# Add your reusable NixOS modules to this directory, on their own file (https://nixos.wiki/wiki/Module).
# These should be stuff you would like to share with others, not your personal configurations.
{inputs, pkgs, config, lib, ...} :
let
  moduleNameSpace = "JackwySystemMods";
  args = { inherit inputs pkgs config lib moduleNameSpace; };
in 
{
  # List your module files here
  # my-module = import ./my-module.nix;
  jujutsu = import ./jujutsu.nix;
  fonts = import ./fonts.nix args;
  network = import ./network.nix;

  JackwySystemMods.fonts.enable = true;
}
