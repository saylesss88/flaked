{
  lib,
  pkgs,
  inputs,
  config, # Add config to the arguments for accessing config.networking.hostName etc.
  ...
}: let
  PRIMARYUSBID = "B7B4-863B"; # From `blkid /dev/sda1`
  BACKUPUSBID = "Ventoy"; # Optional secondary USB
in {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./disk-config2.nix
    ./users.nix
    ./security.nix
    inputs.lib.nixOsModules
    inputs.sops-nix.nixosModules.sops
    inputs.lanzaboote.nixosModules.lanzaboote
    ./impermanence.nix
    ./sops.nix
  ];

  # boot.initrd.luks.devices = {
  #   cryptroot = {
  #     device = "/dev/disk/by-partlabel/luks";
  #     allowDiscards = true;
  #     # fallbackToPassword = true;
  #   };
  # };
  boot.initrd.kernelModules = [
    "uas"
    "usbcore"
    "usb_storage"
    "vfat"
    "nls_cp437"
    "nls_iso8859_1"
  ];

  boot.initrd.postDeviceCommands = lib.mkBefore ''
    mkdir -p /key
    sleep 2
    mount -n -t vfat -o ro $(findfs UUID=${PRIMARYUSBID}) /key || \
    mount -n -t vfat -o ro $(findfs UUID=${BACKUPUSBID}) /key || echo "No USB key found"
  '';

  boot.initrd.luks.devices.cryptroot = {
    device = "/dev/disk/by-partlabel/luks";
    keyFile = "/key/usb-luks.key";
    fallbackToPassword = true;
    allowDiscards = true;
    preLVM = false; # Crucial!
  };

  services.btrfs.autoScrub = {
    enable = true;
    interval = "weekly";
    fileSystems = ["/"];
  };

  networking.hostName = "magic"; # Define your hostname.

  # It seems like 'custom' might be a custom module that bundles other modules.
  # If so, ensure inputs.lib.nixOsModules correctly points to its definition.
  # Otherwise, these would be top-level options.
  custom = {
    magic.enable = true; # bundle of nixos modules
    magic.timezone = "America/New_York";
    magic.hostname = "magic";
    magic.locale = "en_US.UTF-8";
    boot.enable = true;
    users.enable = true;
    nix.enable = true;
    drivers.amdgpu.enable = true;
    cachix.enable = true;
    zram.enable = true;
    lsp.enable = true;
    utils.enable = true;
  };

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "symbola"
      "codeium"
      # "obsidian"
      # "unrar"
    ];

  nixpkgs.overlays = [
    inputs.lib.overlays
  ];

  # During system activation, compare the closure size difference between the current and new system and display a formatted table if significant changes are detected.
  system.activationScripts.diff = ''
    if [[ -e /run/current-system ]]; then
      ${pkgs.nushell}/bin/nu -c "let diff_closure = (${pkgs.nix}/bin/nix store diff-closures /run/current-system '$systemConfig'); let table = (\$diff_closure | lines | where \$it =~ KiB | where \$it =~ → | parse -r '^(?<Package>\S+): (?<Old>[^,]+)(?:.*) → (?<New>[^,]+)(?:.*), (?<DiffBin>.*)$' | insert Diff { get DiffBin | ansi strip | into filesize } | sort-by -r Diff | reject DiffBin); if (\$table | get Diff | is-not-empty) { print \"\"; \$table | append [[Package Old New Diff]; [\"\" \"\" \"\" \"\"]] | append [[Package Old New Diff]; [\"\" \"\" \"Total:\" (\$table | get Diff | math sum) ]] | print; print \"\" }"
    fi
  '';

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    vim
    git
  ];

  time.timeZone = "America/New_York";

  console.keyMap = "us";

  nixpkgs.config.allowUnfree = true; # This is global, duplicates the predicate slightly.

  system.stateVersion = "25.05";
}
