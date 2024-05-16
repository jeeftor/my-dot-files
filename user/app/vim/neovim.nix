{ config, lib, pkgs, ... }:


{
  #https://gist.github.com/nat-418/d76586da7a5d113ab90578ed56069509
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    plugins = with pkgs.vimPlugins; [
      nvim-lspconfig
      nvim-treesitter.withAllGrammars
      plenary-nvim
      gruvbox-material
      mini-nvim
      # (fromGitHub "HEAD" "elihunter173/dirbuf.nvim")
    ];
    # Use the Nix package search engine to find
    # even more plugins : https://search.nixos.org/packages
  };
}
