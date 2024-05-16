# Funciton definition
{ config, pkgs, ... }:

# Return set
let
  myAliases = {
    # Look into LSD at some point
    # LS Style stuffl
    #ld - lists only directories (no files)
    #lf - lists only files (no directories)
    #lh - lists only hidden files (no directories)
    #ll - lists everything with directories first
    #ls - lists only files sorted by size
    #lt - lists everything sorted by time updated

    ls = "lsd";
    ll = "ls --tree";

    pst = "pstree -p $(echo $$) -w";

    # ld = "eza -lD";
    # lf = "eza -lF --color=always | grep -v /";
    # lh = "eza -dl .* --group-directories-first";
    # ll = "eza -al --group-directories-first";
    # ls = "eza -alF --color=always --sort=size | grep -v /";
    # lt = "eza -al --sort=modified";


    # ls = "ls --group-directories-first --color=auto -F -h";
    gg = "git log --oneline --abbrev-commit --decorate --all --graph --date=relative  --pretty=format:\"%C(bold blue)%h%Cred%d %Creset%s\"";
    gg1 = "git log --oneline --abbrev-commit --decorate --all --graph --date=relative  --pretty=format:\"%C(bold blue)%h%Cred%d %C(reset)%s %C(bold green)(%ar)%C(reset) %Cgreen - %cn\"";
    jq = "gojq";
    top = "btop";
    cat = "bat --paging never";



  };
in
{

  # Let home maanger enable bash
  programs.bash = {
    enable = true;

    shellAliases = myAliases;
    enableCompletion = true;
    initExtra = ''
      echo "bash initExtra"
      [ -f ${pkgs.fzf}/share/bash-completion/completions/fzf.bash ] && source ${pkgs.fzf}/share/bash-completion/completions/fzf.bash
      [ -f ${pkgs.fzf}/share/fzf/shell/key-bindings.bash ] && source ${pkgs.fzf}/share/fzf/shell/key-bindings.bash
      [ -f ${pkgs.fzf}/share/bash-completion/completions/fzf.bash ] && source ${pkgs.fzf}/share/bash-completion/completions/fzf.bash
      [ -f ${pkgs.fzf}/share/fzf/shell/key-bindings.bash ] && source ${pkgs.fzf}/share/fzf/shell/key-bindings.bash      
      set -o emacs
    '';
  };

  programs.zsh = {
    enable = true;
    shellAliases = myAliases;
    enableCompletion = true;
    initExtra = ''
      echo "zsh initExtra"
      setopt CORRECT

      [ -f ${pkgs.fzf}/share/zsh/site-functions/_fzf ] && source ${pkgs.fzf}/share/zsh/site-functions/_fzf
      [ -f ${pkgs.fzf}/share/fzf/shell/key-bindings.zsh ] && source ${pkgs.fzf}/share/fzf/shell/key-bindings.zsh
      
      set -o emacs
    '';
  };



  home.packages = with pkgs; [
    bat
    btop
    delta
    direnv
    # Not work for mac?
    #fastfetch
    fd
    fzf
    gojq
    gum
    # just
    lsd
    ncdu
    nix-direnv
    ripgrep
    sops
    zoxide
    zsh-fzf-tab
    coreutils
    pstree
    # eza
  ];

  programs.bat = {
    enable = true;
  };

  programs.ripgrep.enable = true;

  programs.lsd = {
    enable = true;
    settings = {
      # icons = true;
      # tree = true;
      # hyperlink = "always";
      #date = "+%Y-%m-%d %r";
      date = "+%D %R";
      ignore-globs = [ ".git" ".hg" "Libraryss" ];
    };
  };

  # Disalbed i prefer LSD
  # programs.eza =
  #   {
  #     enable = false;
  #     # icons = true;
  #     # enableZshIntegration = true;
  #     # enableBashIntegration = true;
  #   };


  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableNushellIntegration = true;
    enableZshIntegration = true;
  };


  programs.git = {
    enable = true;
    userName = "Jeef";
    userEmail = "jeffstein@gmail.com";
    delta.enable = true;
    # pager = "delta";
  };

}
