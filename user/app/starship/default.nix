{ lib, pkgs, ... }:

{
  # home.file.".config/starship.toml".source = ./starship.toml;

  home.packages = with pkgs; [
    starship

  ];

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
  };

  programs.starship.settings = {
    add_newline = false;
    format = "$os$username$hostname $directory $character";
    right_format = "$localip$shlvl$singularity$kubernetes$vcsh$fossil_branch$fossil_metrics$git_branch$git_commit$git_state$git_metrics$git_status$hg_branch$pijul_channel$docker_context$package$c$cmake$cobol$daml$dart$deno$dotnet$elixir$elm$erlang$fennel$gleam$golang$guix_shell$haskell$haxe$helm$java$julia$kotlin$gradle$lua$nim$nodejs$ocaml$opa$perl$php$pulumi$purescript$python$quarto$raku$rlang$red$ruby$rust$scala$solidity$swift$terraform$typst$vlang$vagrant$zig$buf$nix_shell$conda$meson$spack$memory_usage$aws$gcloud$openstack$azure$nats$direnv$crystal$custom$sudo$cmd_duration$line_break$jobs$battery$time$status$container$shell$env_var";


    os = {
      format = "$symbol";
      disabled = false;

    };
    character = {
      success_symbol = "[❯](red)[❯](yellow)[❯](green)";
      error_symbol = "[❯](red)[❯](yellow)[❯](red)";
      vicmd_symbol = "[❮](green)[❮](yellow)[❮](red)";

    };
    git_branch = {
      format = "[$symbol$branch(:$remote_branch)]($style)";
      symbol = " ";
      style = "bold green";
    };
    python = {
      format = "($virtualenv) ";
    };
    git_status = {
      format = "$all_status$ahead_behind ";
      ahead = "[⬆](bold purple) ";
      behind = "[⬇](bold purple) ";
      staged = "[✚](green) ";
      deleted = "[✖](red) ";
      renamed = "[➜](purple) ";
      stashed = "[✭](cyan) ";
      untracked = "[◼](white) ";
      modified = "[✱](blue) ";
      conflicted = "[═](yellow) ";
      diverged = "⇕ ";
      up_to_date = "";
    };
    cmd_duration = {
      format = "[$duration]($style) ";

    };
    line_break = {
      disabled = false;
    };
    status = {
      disabled = false;
      symbol = "✘ ";
    };
    username = {
      style_user = "blue bold";
      style_root = "black bold";
      format = "[$user]($style)";
      disabled = false;
      show_always = true;
    };
    hostname = {
      ssh_only = true;
      ssh_symbol = "@";
      style = "bold green";
      format = "[$ssh_symbol$hostname]($style)";
    };
    directory = {
      format = "[$path]($style)[$read_only]($read_only_style)";
      style = "yellow";
      truncation_length = 3;
      truncate_to_repo = true;
      truncation_symbol = "";
    };
    sudo = {
      disabled = false;
    };
    shlvl = {
      threshold = 2;
      disabled = false;
    };
    env_var = {
      SSH_CONNECTION = {
        format = "[∙](blink #2BFF00)";
      };
      # TO get a glyf:  echo $'\uf4c3'   
    };
  };

}
