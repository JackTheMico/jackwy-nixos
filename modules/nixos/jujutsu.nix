{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    jujutsu
    lazyjj
  ];
}
