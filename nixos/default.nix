{
  myLib,
  lib,
  config,
  ...
}: {
  imports = myLib.scanPaths ./.;

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

    # Assertions to check if required variables are set when magic is enabled
    assertions = lib.mkIf config.custom.magic.enable [
      {
        assertion = config.custom.magic.hostname != "";
        message = "magic.hostname must be set";
      }
      {
        assertion = config.custom.magic.timezone != "";
        message = "magic.timezone must be set";
      }
      {
        assertion = config.custom.magic.locale != "";
        message = "magic.locale must be set";
      }
    ];

    # Configuration for variables (only applied when magic is enabled)
    time.timeZone = lib.mkIf config.custom.magic.enable config.custom.magic.timezone;
    i18n.defaultLocale = lib.mkIf config.custom.magic.enable config.custom.magic.locale;
    networking.hostName = lib.mkIf config.custom.magic.enable config.custom.magic.hostname;

    system.stateVersion = "25.05";
  };
}
