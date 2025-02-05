# My system level fonts settings
{pkgs, ...}: {
  fonts.packages = with pkgs; [
    # Possible system defaut fonts
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    (nerdfonts.override {fonts = ["Hack" "FiraCode"];})
  ];
}
