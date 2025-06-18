{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.custom.utils;
in {
  options.custom.utils = {
    enable = lib.mkEnableOption "Enable utils module";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = builtins.attrValues {
      inherit
        (pkgs)
        vim
        rustup
        htop
        vivid
        age
        sops
        nickel
        wasistlos
        obsidian
        nufmt
        evcxr
        sbctl
        git-filter-repo
        cheat # Display cheat sheets for commands
        nssmdns
        lsof
        yamllint
        statix
        sqlite
        hugo
        nix-eval-jobs
        nix-info
        nix-tree
        entr
        findutils
        inxi # show detailed system info
        mkpasswd
        wget
        eza
        clinfo
        efibootmgr # manage EFI boot entries
        inotify-tools # utility for monitoring file system events
        unrar # tool to extract RAR archives
        duf # Disk usage/free utility
        ncdu # Disk usage analyzer
        pciutils # Inspect PCI devices
        socat # multipurpose relay tool
        ripgrep
        lshw # display detailed hardware info
        nix-prefetch-git
        nix-prefetch-github
        tree
        cachix
        dconf2nix # util to generate Nix code from dconf settings
        dmidecode # tool to retrieve system hardware info from BIOS
        _7zz # tool for 7z archives (this might need to be pkgs._7zz or pkgs.sevenzip, depending on the exact package name)
        p7zip
        alsa-utils # util for ALSA sound
        nix-diff # tool to compare derivations
        just # Moved inside inherit block
        unzip
        meson
        ninja
        gcc
        binutils
        libgcc
        gnumake
        cmake
        openssl # toolkit for TLS/SSL
        pkg-config
        ;

      # For deeply nested attributes, you need to reference them directly
      # and then include them in the list.
      # Note: 'cpupower' is part of the kernel packages.
      # We reference it explicitly here.
      inherit (pkgs.linuxKernel.packages.linux_zen) cpupower;

      # If 'nix-inspect' is from a different input, you'd add it like this:
      # nixInspect = inputs.nix-inspect.packages.${pkgs.system}.default;
    };
  };
}
