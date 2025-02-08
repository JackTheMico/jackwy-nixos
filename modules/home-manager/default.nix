# Add your reusable home-manager modules to this directory, on their own file (https://nixos.wiki/wiki/Module).
# These should be stuff you would like to share with others, not your personal configurations.
{inputs, pkgs, lib, config, ...} :
let
  moduleNameSpace = "JackwyHMMods";
  args = { inherit inputs pkgs lib config moduleNameSpace; };
in 
{
  # List your module files here
  obsidian = import ./obsidian.nix;
  hyprland = import ./hyprland.nix;
  wezterm = import ./wezterm.nix args;

  JackwyHMMods.wezterm.enable = true;
}
