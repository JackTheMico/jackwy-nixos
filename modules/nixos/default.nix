# Add your reusable NixOS modules to this directory, on their own file (https://nixos.wiki/wiki/Module).
# These should be stuff you would like to share with others, not your personal configurations.
{
  inputs,
  system,
  ...
}: let
  moduleNameSpace = "jackwySystemMods";
  args = {inherit moduleNameSpace inputs system;};
in {
  # List your module files here
  # my-module = import ./my-module.nix;
  vcs = import ./vcs.nix args;
  fontProfiles = import ./fonts.nix args;
  network = import ./network.nix args;
  hack = import ./hack.nix args;
  basic = import ./basic.nix args;
  nutstore = import ./nutstore.nix args;
  gaming = import ./gaming.nix args;
}
