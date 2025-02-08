# Add your reusable home-manager modules to this directory, on their own file (https://nixos.wiki/wiki/Module).
# These should be stuff you would like to share with others, not your personal configurations.
{inputs, ...} :
let
  moduleNameSpace = "JackwyHMMods";
  args = { inherit inputs moduleNameSpace; };
in 
{
  # List your module files here
  obsidian = import ./obsidian.nix;
  hyprland = import ./hyprland.nix;
  wezterm = import ./wezterm.nix args;

  JackwyHMMods.wezterm.enable = true;
}
