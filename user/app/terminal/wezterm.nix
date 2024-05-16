{ lib, pkgs, ... }:

{

  home.packages = with pkgs; [
    wezterm
    (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" ]; })
  ];

  programs.wezterm.enable = true;
  programs.wezterm.enableZshIntegration = true;

}

