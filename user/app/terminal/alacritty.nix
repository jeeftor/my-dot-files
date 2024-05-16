{ lib, pkgs, ... }:

let
  # font = "JetbrainsMono Nerd Font";
  font = "JetbrainsMono Nerd Font Mono";
  # font = "FiraCode Nerd Font";
in
{

  # home.file.".config/alacritty/alacritty.toml".source = ./alacritty.toml;

  home.packages = with pkgs; [
    alacritty
    # Nerd fonts need to be intalled elsehwere i think - like in a fonts block
    # (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" ]; })
  ];

  programs.alacritty.enable = true;
  programs.alacritty.settings = {

    live_config_reload = true;
    # shell = {
    #   program = "zsh";
    #   args = [ "-l" ];
    # };
    scrolling = {
      history = 10000;
      multiplier = 3;
    };

    window.dimensions = {
      lines = 40;
      columns = 120;
    };
    font = {
      size = 13.5;
      # Offset is the extra space around each character. `offset.y` can be thought of
      # as modifying the line spacing, and `offset.x` as modifying the letter spacing
      # I've given in 14 spacing which fits really well with my fonts, you may change it
      # to your convenience but make sure to adjust 'glyph_offset' appropriately post that
      # offset = {
      #   x = 0;
      #   y = 0;
      # };

      # Note: This requires RESTART
      # By default when you change the offset above you'll see an issue, where the texts are bottom
      # aligned with the cursor, this is to make sure they center align.
      # This offset should usually be 1/2 of the above offset-y being set.
      # glyph_offset = {
      #   x = 0;
      #   # Keeping this as half of offset to vertically align the text in cursor
      #   y = 7;
      # };

      # normal = "{ family = "JetBrainsMono Nerd Font Mono", style = "Regular" }";

      normal = {
        family = "${font}";
        style = "Light";
      };
      bold = {
        family = "${font}";
        style = "Medium";

      };
      italic = {
        family = "${font}";
        style = "Italic";
      };
      bold_italic = {
        family = "${font}";
        style = "Bold Italic";
      };
    };

    cursor = {
      style = {
        blinking = "On";
      };
    };


    #https://arslan.io/2018/02/05/gpu-accelerated-terminal-alacritty/#make-alacritty-feel-like-iterm2
  };


  #   window.opacity = lib.mkForce 0.75;
}
