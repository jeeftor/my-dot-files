{ inputs, pkgs, self, ... }: {

  imports = [
    ./shellConfig.nix
    ./app/terminal/alacritty.nix
    ./app/terminal/wezterm.nix
    ./app/starship
    ./app/ssh/ssh_lan.nix
    # ./app/zellij/zellij.nix
    ./app/unfree.nix
    ./app/vim/neovim.nix
  ];
}
