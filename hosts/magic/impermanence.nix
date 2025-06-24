{lib, ...}: {
  boot.initrd.postResumeCommands = lib.mkAfter ''
    mkdir -p /btrfs_tmp
    mount -o subvolid=5 /dev/mapper/cryptroot /btrfs_tmp || {
      echo "Failed to mount Btrfs root" >&2
      exit 1
    }

    # Check if root subvolume exists and move it to a backup
    if [[ -e /btrfs_tmp/root ]]; then
      mkdir -p /btrfs_tmp/old_roots
      timestamp=$(date "+%Y-%m-%d_%H:%M:%S")
      mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
    fi

    # Recursively delete subvolumes
    delete_subvolume_recursively() {
      local path="$1"
      IFS=$'\n'
      for i in $(btrfs subvolume list -o "$path" | cut -f 9- -d ' '); do
        delete_subvolume_recursively "/btrfs_tmp/$i"
      done
      if ! btrfs subvolume delete "$path" 2>/tmp/subvol_delete_error.log; then
        echo "Failed to delete subvolume $path, check /tmp/subvol_delete_error.log" >&2
      fi
    }

    # Clean up old backups (keep last 30 days)
    for i in $(btrfs subvolume list /btrfs_tmp | grep 'old_roots/' | awk '$NF ~ /old_roots\/[0-9]{4}-[0-9]{2}-[0-9]{2}_[0-9]{2}:[0-9]{2}:[0-9]{2}/ {print $NF}' | while read -r subvol; do
      if [[ $(find "/btrfs_tmp/$subvol" -mtime +30) ]]; then
        echo "/btrfs_tmp/$subvol"
      fi
    done); do
      delete_subvolume_recursively "$i"
    done

    # Create a fresh root subvolume
    btrfs subvolume create /btrfs_tmp/root || {
      echo "Failed to create new root subvolume" >&2
      exit 1
    }
    umount /btrfs_tmp
  '';

  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/etc/ssh"
      "/etc/nixos"
      "/etc/NetworkManager/system-connections"
      "/var/spool"
      "/srv"
      "/var/lib/systemd"
      "/var/lib/bluetooth"
    ];
    files = [
      "/etc/machine-id"
    ];
  };
}
