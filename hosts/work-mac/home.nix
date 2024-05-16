{ inputs, config, pkgs, lib, ... }: {



  imports = [
    ../../user
    # ../../user/linux.nix

  ];

  home.sessionVariables = {

    # Set this SSL Cert stuff
    NODE_EXTRA_CA_CERTS = "/Users/jstein/.dotfiles/WORK-chain.crt";
  };

  home = {
    # Home manager state is a number - nixOS state is NOT
    stateVersion = "24.05";

    packages = with pkgs; [

      # (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" ]; })

      starship
      gojq
      imgcat
      git
      ripgrep
      mpv
      coreutils
      element-desktop

      # zellij

      # fastfetch

      # zip
      # unzip
      # tmux
      # spotify
      # sqlite
      # ripgrep
      # openssl
      # postgresql
      # inetutils
      # bind
      # fzf
      # difftastic
      # nushell
      # atuin
      # mpv
      # python3
      # jq
      # yq
      # qbittorrent
      # wget
      # dive
      # ffmpeg
      # kotlin
      # shellcheck
      # zoom-us
      # nixpkgs-fmt
      # gradle_7
      # texliveFull


      # # kubernetes related packages
      # kubernetes-helm
      # kind

      # password store related packages
      # gopass
      # gopass-jsonapi
      # passExtensions.pass-update

      # macOS has pbcopy/pbpaste, nevertheless
      xsel


    ];
  };

  programs.home-manager.enable = true;
  # programs = {
  #   # htop = {
  #   #   enable = true;
  #   #   settings.color_scheme = 6;
  #   # };

  # home-manager = {
  #   enable = true;
  # };

  #   # password-store = {
  #   #   enable = true;
  #   # };
  # };

}
