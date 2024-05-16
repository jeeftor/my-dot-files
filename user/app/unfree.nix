{ allowed-unfree-packages, lib, config, pkgs, ... }:

{
  nixpkgs.config = {
    allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) allowed-unfree-packages;
  };

  home.packages = with pkgs; [
    # Packages need to also be listed in the flake file.
    # in the allowed-unfree-packages block - unless i can modify it here?
    discord
    vscode
  ];


  programs.vscode.userSettings = {
    # Allow copilot to work
    github.copilot.advanced = {
      "debug.useNodeFetcher" = true;
    };

    editor = {
      fontFamily = "'JetBrains Mono Nerd Font', 'Fira Code Nerd Font'";
      fontSize = 14;
      fontLigatures = true;
    };



  };

  programs.vscode.extensions = [
    pkgs.vscode-extensions.bbenoist.nix
  ];

}
