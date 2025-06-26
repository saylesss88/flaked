{
  config,
  lib,
  ...
}: {
  boot.initrd.postDeviceCommands = lib.mkAfter ''
    mkdir /mnt
    mount -t btrfs /dev/mapper/cryptroot /mnt # <--- Changed 'enc' to 'cryptroot'
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
      "${config.home.sessionVariables.HOME}/.mozilla/firefox"
    ];
    files = [
      "/etc/machine-id"
      ".mozilla/firefox/profiles.ini"
      # Add more files you want to persist
    ];
  };

  security.sudo.extraConfig = ''
    Defaults lecture = never
  '';
}
