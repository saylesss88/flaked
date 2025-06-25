{
  config,
  lib,
  ...
}: {
  boot.initrd.postMountCommands = lib.mkAfter ''
    mkdir -p /mnt
    mount -o subvol=/ /dev/mapper/cryptroot /mnt

    # Remove subvolumes under root (if any)
    btrfs subvolume list -o /mnt |
      cut -f9 -d' ' |
      while read subvolume; do
        echo "Deleting /$subvolume subvolume..."
        btrfs subvolume delete "/mnt/$subvolume"
      done

    # Delete the root subvolume itself
    echo "Deleting root subvolume..."
    btrfs subvolume delete /mnt

    # Restore from the blank snapshot
    echo "Restoring blank root subvolume..."
    btrfs subvolume snapshot /mnt/root-blank /mnt

    umount /mnt
  '';

  environment.persistence."/persist" = {
    directories = [
      "/etc"
      "/var/spool"
      "/root"
      "/srv"
      "/etc/NetworkManager/system-connections"
      "/var/lib/bluetooth"
    ];
    files = [
      "/etc/machine-id"
      # Add more files you want to persist
    ];
  };

  security.sudo.extraConfig = ''
    Defaults lecture = never
  '';
}
