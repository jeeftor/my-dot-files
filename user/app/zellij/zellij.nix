{ lib, pkgs, ... }:

{

  home.packages = with pkgs; [
    zellij
  ];
  programs.zellij.enable = true;
  programs.zellij.enableZshIntegration = true;
  programs.zellij.enableBashIntegration = false;
  programs.zellij.settings = {
    default_shell = "zsh";
  };
  # programs.alacritty.enable = true;
  # programs.alacritty.settings = {
  #   window.opacity = lib.mkForce 0.75;
  # };
}
