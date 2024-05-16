{ config, lib, pkgs, modulesPath, ... }:

{

  networking.hosts =
    {
      "192.168.1.3" = [ "pve1.vookie.net" "pve1" "pve1.local" ];
      "192.168.1.4" = [ "pve2.vookie.net" "pve2" "pve2.local" ];
      "192.168.1.5" = [ "pve3.vookie.net" "pve3" "pve3.local" ];
    };
}
