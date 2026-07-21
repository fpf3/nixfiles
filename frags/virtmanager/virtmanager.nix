{pkgs, ...}:
{
  virtualisation.libvirtd.qemu.vhostUserPackages = [
    pkgs.virtiofsd
  ];

  programs.virt-manager.enable = true;
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
}
