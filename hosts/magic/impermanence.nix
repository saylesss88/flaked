{
  config,
  lib,
  ...
}: {
  boot.initrd.postDeviceCommands = lib.mkAfter ''
    echo "Rollback running" > /mnt/rollback.log
    mkdir /mnt
    mount -t btrfs /dev/mapper/cryptroot /mnt
    btrfs subvolume delete /mnt/root
    btrfs subvolume snapshot /mnt/root-blank /mnt/root
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
      # "/etc/machine-id"
      # Add more files you want to persist
    ];
  };

  security.sudo.extraConfig = ''
    Defaults lecture = never
  '';
}
