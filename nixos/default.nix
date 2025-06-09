{
  lib,
  config,
  ...
}: let
  cfg = config.custom.magic;
in {
  imports = [
    ./networking.nix
    ./greetd.nix
    ./drivers
    ./fonts.nix
    ./boot.nix
    ./nix.nix
    ./cachix.nix
    ./bluetooth.nix
    ./programs.nix
    ./thunar.nix
    ./keyd.nix
    ./lsp.nix
    ./environmentVariables.nix
    ./pipewire.nix
    ./zram.nix
    ./utils.nix
    ./xdg.nix
    ./services.nix
    ./i18n.nix
  ];

  options.custom.magic = {
    enable = lib.mkEnableOption "Enable magic modules globally";

    hostname = lib.mkOption {
      type = lib.types.str;
      description = "Hostname";
      example = "magic";
    };

    timezone = lib.mkOption {
      type = lib.types.str;
      description = "Timezone";
      example = "America/New_York";
    };

    locale = lib.mkOption {
      type = lib.types.str;
      description = "Locale";
      example = "en_US.UTF-8";
    };
  };

  config = {
    custom.magic.enable = lib.mkDefault false;

    # Assertions to check if required variables are set when hydenix is enabled
    assertions = lib.mkIf cfg.enable [
      {
        assertion = cfg.hostname != "";
        message = "magic.hostname must be set";
      }
      {
        assertion = cfg.timezone != "";
        message = "magic.timezone must be set";
      }
      {
        assertion = cfg.locale != "";
        message = "magic.locale must be set";
      }
    ];

    # Configuration for variables (only applied when hydenix is enabled)
    time.timeZone = lib.mkIf cfg.enable cfg.timezone;
    i18n.defaultLocale = lib.mkIf cfg.enable cfg.locale;
    networking.hostName = lib.mkIf cfg.enable cfg.hostname;

    system.stateVersion = "25.05";
  };
}
