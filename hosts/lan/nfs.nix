{ config, lib, pkgs, modulesPath, ... }:

{
  environment.systemPackages = with pkgs; [
    # Other packages...
    nfs-utils
  ];
  fileSystems."/mnt/sharedstorage" = {
    device = "192.168.1.5:/data/sharedstorage";
    fsType = "nfs";
  };

}
