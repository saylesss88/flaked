{
  lib,
  pkgs,
  inputs,
  config, # Add config to the arguments for accessing config.networking.hostName etc.
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
    inputs.lib.overlays # Assuming inputs.lib.overlays is a list of overlays
  ];

  # During system activation, compare the closure size difference between the current and new system and display a formatted table if significant changes are detected.
  system.activationScripts.diff = ''
    if [[ -e /run/current-system ]]; then
      ${pkgs.nushell}/bin/nu -c "let diff_closure = (${pkgs.nix}/bin/nix store diff-closures /run/current-system '$systemConfig'); let table = (\$diff_closure | lines | where \$it =~ KiB | where \$it =~ → | parse -r '^(?<Package>\S+): (?<Old>[^,]+)(?:.*) → (?<New>[^,]+)(?:.*), (?<DiffBin>.*)$' | insert Diff { get DiffBin | ansi strip | into filesize } | sort-by -r Diff | reject DiffBin); if (\$table | get Diff | is-not-empty) { print \"\"; \$table | append [[Package Old New Diff]; [\"\" \"\" \"\" \"\"]] | append [[Package Old New Diff]; [\"\" \"\" \"Total:\" (\$table | get Diff | math sum) ]] | print; print \"\" }"
    fi
  '';

  specialisation = {
    saylesss.configuration = {
      system.nixos.tags = ["saylesss"];

      wayland.windowManager.sway = {
        enable = true;
        checkConfig = false;
        config = rec {
          modifier = "Mod4"; # Changed from `mod` to explicit string
          terminal = "${pkgs.ghostty}/bin/ghostty";
          startup = [{command = "firefox";}];
          floating.border = 0;
          window.border = 0;
          gaps = {
            inner = 5;
            smartGaps = true;
          };
        }; # <--- Correct closing for `config`

        # extraConfig is an option at the same level as `enable`, `checkConfig`, `config`
        extraConfig = ''
          seat * xcursor_theme bibata_modern_ice 26
          set $mod Mod4 # This is where $mod is actually defined for Sway's config

          # bindsym ${mod}+Shift+minus move scratchpad
          # bindsym ${mod}+minus scratchpad show

          exec waybar &
          exec nm-applet --indicator
          exec wl-paste --type text --watch cliphist store
          exec wl-paste --type image --watch cliphist store

          output DP-1 {
            # bg /home/jr/Pictures/Wallpapers/mountains1.jpg fill
            mode 3840x2160@65Hz
            scale 1.5
            pos 0 0
          }

          output HDMI-A-1 {
            mode 1920x1080@100Hz
            scale 1
            pos 2560 0
          }

          input * {
            repeat_delay 300
            repeat_rate 50
          }
          # SwayFx settings
          # shadows enable
          # blur_radius 7
          # blur_passes 4
          exec ${pkgs.wpaperd}/bin/wpaperd -d
        '';
      };

      services = {
        network-manager-applet.enable = true;
        cliphist.enable = true;
      };

      home.packages = with pkgs; [
        grim
        mako
        wl-clipboard
        rofi-wayland
        slurp
        wpaperd
        pavucontrol
        swappy
        swaylock-effects
        yad
        findutils
        wtype
      ];
    };
  };

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
