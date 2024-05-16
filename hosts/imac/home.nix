{ config, pkgs, ... }: {

  imports = [
    ../../user
  ];

  home = {
    stateVersion = "24.05";
    username = "jstein";
    homeDirectory = "/home/jstein";

    # host-level packages
    packages = with pkgs; [
      git
      # alacritty
      signal-desktop
      ssh-to-age
      age
      sops

      # unzip
      # tmux
      # vscode
      # google-chrome
      # spotify
      # nextcloud-client
      # tailscale
      # sqlite3 is a must dependency of emacs, nevertheless I love sqlite
      # sqlite
      # ripgrep
      # openssl
      # postgresql
      # inetutils # network utilities like telnet etc
      # bind # more network utilities like dig etc
      # fzf
      # inotify-tools
      # difftastic
      # nushell
      # atuin
      # flameshot
      # mpv
      # vlc
      # python3
      # jq
      # yq
      # qbittorrent
      # wget
      # dive
      # ffmpeg
      # shellcheck
      # # postman
      # krita
      # qutebrowser
      # zoom-us
      # nixpkgs-fmt
      # texliveFull

      # password store related packages
      # gopass
      # gopass-jsonapi
      # passExtensions.pass-update

      # # copy/pasting via command line
      # xsel
      # # getting battery and temperature information
      # acpi
      # # getting currently playing media information
      # playerctl
    ];
  };

  programs = {
    # htop = {
    #   enable = true;
    #   settings.color_scheme = 6;
    # };

    home-manager = {
      enable = true;
    };

    # password-store = {
    #   enable = true;
    # };
  };
}
