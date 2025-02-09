# Add your reusable home-manager modules to this directory, on their own file (https://nixos.wiki/wiki/Module).
# These should be stuff you would like to share with others, not your personal configurations.
let
  moduleNameSpace = "jackwyHMMods";
  args = { inherit moduleNameSpace;};
in 
{
  # List your module files here
  obsidian = import ./obsidian.nix args;
  hyprland = import ./hyprland args;
  wezterm = import ./wezterm args;
}
