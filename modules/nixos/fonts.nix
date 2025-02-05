# My system level fonts settings
{pkgs, ...}: {
  fonts.packages = with pkgs; [
    (nerdfonts.override {fonts = ["Hack" "FiraCode"];})
  ];
}
