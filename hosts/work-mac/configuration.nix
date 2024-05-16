{ inputs, config, pkgs, lib, ... }:

{


  # networking.hosts =
  #   {
  #     "192.168.1.3" = [ "pve1.vookie.net" "pve1" "pve1.local" ];
  #     "192.168.1.4" = [ "pve2.vookie.net" "pve2" "pve2.local" ];
  #     "192.168.1.5" = [ "pve3.vookie.net" "pve3" "pve3.local" ];
  #   };


  # nix.settings = {
  #   # this is required because flakes hasn't graduated into a stable feature yet
  #   experimental-features = [ "nix-command" "flakes" "recursive-nix" ];
  # };

  services.nix-daemon.enable = true;

  networking.hostName = "MM304565-PC";

  users.users.jstein = {
    # workaround for https://github.com/nix-community/home-manager/issues/4026
    home = "/Users/jstein";
    packages = with pkgs; [
      git
      zsh
      # fastfetch
    ];
    shell = pkgs.zsh;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # TODO: generalize the username here
  #system.activationScripts.postActivation.text = ''
  #  chsh -s /run/current-system/sw/bin/zsh jstein
  #'';


  fonts.fontDir.enable = true;
  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" ]; })
  ];


}
