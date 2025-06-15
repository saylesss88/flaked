{lib, ...}: {
  # Reset root subvolume on boot
  boot.initrd.postResumeCommands = lib.mkAfter ''
    mkdir /btrfs_tmp
    mount /dev/disk/by-partlabel/disk-main-root /btrfs_tmp # CONFIRM THIS IS CORRECT FROM findmnt
    if [[ -e /btrfs_tmp/root ]]; then
      mkdir -p /btrfs_tmp/old_roots
      timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
      mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
    fi

    delete_subvolume_recursively() {
      IFS=$'\n'
      for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
        delete_subvolume_recursively "/btrfs_tmp/$i"
      done
      btrfs subvolume delete "$1"
    }

    for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
      delete_subvolume_recursively "$i"
    done

    btrfs subvolume create /btrfs_tmp/root
    umount /btrfs_tmp
  '';

  # Use /persist as the persistence root, matching Disko's mountpoint
  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/etc" # System configuration (Keep this here for persistence via bind-mount)
      "/var/spool" # Mail queues, cron jobs
      "/srv" # Web server data, etc.
      "/root" # Root user's home
      # "/var/log" # Persist logs for debugging (still commented out, good)
    ];
    files = [
      # "/swapfile" # Persist swapfile (impermanence manages this file)
    ];
  };

  # Swapfile configuration (definition for Systemd)
  swapDevices = [
    {
      device = "/persist/swapfile"; # Points to the persistent location of the swapfile
      size = 8192; # 8 GB in MiB
    }
  ];

  # --- SWAPFILE INITIALIZATION & FORMATTING (CRITICAL for activation) ---
  # 1. Ensure the swapfile exists at the specified size with correct permissions early via tmpfiles.
  #    The ${toString (8 * 1024 * 1024 * 1024)} converts 8GB to bytes.
  systemd.tmpfiles.rules = [
    "f /persist/swapfile 0600 - - ${toString (8 * 1024 * 1024 * 1024)} -"
  ];

  # 2. Format the swapfile *only if it's not already formatted* during boot.
  boot.initrd.postDeviceCommands = lib.mkAfter ''
    if ! blkid -p /persist/swapfile | grep -q 'TYPE="swap"'; then
      echo "NixOS: Formatting /persist/swapfile..."
      mkswap /persist/swapfile
    fi
  '';
  # --- END SWAPFILE INITIALIZATION & FORMATTING ---
}
