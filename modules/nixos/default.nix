# Add your reusable NixOS modules to this directory, on their own file (https://nixos.wiki/wiki/Module).
# These should be stuff you would like to share with others, not your personal configurations.
let
  moduleNameSpace = "jackwySystemMods";
  args = {inherit moduleNameSpace;};
in 
{
  # List your module files here
  # my-module = import ./my-module.nix;
  jujutsu = import ./jujutsu.nix args;
  fontProfiles = import ./fonts.nix args;
  network = import ./network.nix args;
  hack = import ./hack.nix args;
}
