{config, lib, pkgs, ...}:
{
  # bootloader config
  boot.loader.grub.zfsSupport = true;

  boot.zfs.forceImportRoot = false;

  # enable ZFS snapshots

  services.zfs.autoSnapshot = {
    enable = true;
    flags = "-k -p --utc -v";
  };

}
