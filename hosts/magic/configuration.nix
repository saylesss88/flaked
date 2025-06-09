{
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./disk-config.nix
    ./users.nix
    ./security.nix
    inputs.lib.nixOsModules
    ./impermanence.nix
  ];

  networking.hostName = "magic"; # Define your hostname.

  custom = {
    magic.enable = true; # bundle of nixos modules
    magic.timezone = "America/New_York";
    magic.hostname = "magic";
    magic.locale = "en_US.UTF-8";
    bootModule.enable = true;
    users.enable = true;
    nixModule.enable = true;
    drivers.amdgpu.enable = true;
    cachixModule.enable = true;
    zram.enable = true;
    lspModule.enable = true;
    utilsModule.enable = true;
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

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "25.05"; # Did you read the comment?
}
