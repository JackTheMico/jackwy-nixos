# Add your reusable home-manager modules to this directory, on their own file (https://nixos.wiki/wiki/Module).
# These should be stuff you would like to share with others, not your personal configurations.
let
  moduleNameSpace = "jackwyHMMods";
  args = { inherit moduleNameSpace; };
in {
  # List your module files here
  obsidian = import ./obsidian.nix args;
  hyprland = import ./hyprland args;
  wezterm = import ./wezterm args;
  chromium = import ./chromium.nix args;
  rofi = import ./rofi args;
  ssh = import ./ssh.nix args;
  sopsnix = import ./sopsnix.nix args;
  gh = import ./gh.nix args;
  qutebrowser = import ./qutebrowser.nix args;
}
