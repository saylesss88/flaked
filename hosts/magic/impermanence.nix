{lib, ...}: {
  #  Reset root subvolume on boot
  boot.initrd.postResumeCommands = lib.mkAfter ''
    mkdir -p /btrfs_tmp
    mount -o subvol=/ /dev/mapper/cryptroot /btrfs_tmp

    # Check if root subvolume exists and move it to a backup
    if [[ -e /btrfs_tmp/root ]]; then
      mkdir -p /btrfs_tmp/old_roots
      timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
      mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
    fi

    # Recursively delete subvolumes under a given path (helper function)
    delete_subvolume_recursively() {
      IFS=$'\n'
      for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
        delete_subvolume_recursively "/btrfs_tmp/$i"
      done
      btrfs subvolume delete "$1"
    }

    # Clean up old backups (optional, keeps only last 30 days)
    for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
      delete_subvolume_recursively "$i"
    done

    # Create a fresh root subvolume
    btrfs subvolume create /btrfs_tmp/root
    umount /btrfs_tmp
  '';

  boot.initrd.luks.devices = {
    crypt = {
      device = "/dev/disk/by-partlabel/luks";
      allowDiscards = true;
      preLVM = true;
    };
  };
  # Use /persist as the persistence root, matching Disko's mountpoint
  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/etc" # System configuration (Keep this here for persistence via bind-mount)
      "/var/spool" # Mail queues, cron jobs
      "/srv" # Web server data, etc.
      "/root"
    ];
    files = [
    ];
  };
}
