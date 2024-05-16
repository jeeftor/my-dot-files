{ lib, pkgs, ... }:

{
  programs.ssh.enable = true;
  # programs.ssh.addKeysToAgent = "yes";
  programs.ssh.extraConfig = ''
    #AdddKeysToAgent yes
    StrictHostKeyChecking no
  '';
  programs.ssh.serverAliveCountMax = 6;
  programs.ssh.serverAliveInterval = 10;
  programs.ssh.forwardAgent = true;
  programs.ssh.compression = true;

  programs.ssh.controlMaster = "auto";
  programs.ssh.controlPath = "~/.ssh/%u.ssh%r@%h-%p";
  programs.ssh.controlPersist = "300s";

  programs.ssh.matchBlocks = {

    router = {
      port = 2222;
      hostname = "192.168.1.1";
      user = "admin";
    };

    "pve1 pve1.local 192.168.1.3" = {
      hostname = "192.168.1.3";
      user = "root";
    };
    "pve2 pve2.local 192.168.1.4" = {
      hostname = "192.168.1.4";
      user = "root";
    };
    "pve3 pve3.local 192.168.1.5" = {
      hostname = "192.168.1.5";
      user = "root";
    };

    imac = {
      hostname = "192.168.1.125";
      user = "jstein";
    };
  };
}
