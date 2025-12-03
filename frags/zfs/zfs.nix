{config, lib, pkgs, ...}:
{
  # bootloader config
  boot.loader.grub.zfsSupport = true;

  # enable ZFS snapshots

  services.zfs.autoSnapshot = {
    enable = true;
    flags = "-k -p --utc -v";
  };

}
