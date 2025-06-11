{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.custom.boot;
in {
  options.custom.boot = {
    enable = lib.mkEnableOption "Enable the Boot Module";
  };

  config = lib.mkIf cfg.enable {
    boot = {
      # LinuxZen Kernel
      kernelPackages = pkgs.linuxPackages_zen;
      consoleLogLevel = 3;
      tmp = {
        useTmpfs = true;
        tmpfsSize = "50%";
      };
      # disable wifi powersave
      extraModprobeConfig = ''
        options iwlmvm  power_scheme=1
        options iwlwifi power_save=0
      '';
      kernelParams = [
        "quiet"
        "systemd.show_status=auto"
        "rd.udev.log_level=3"
        "plymouth.use-simpledrm"
      ];
      kernel.sysctl = {
        "vm.max_map_count" = 2147483642;
      };
      loader = {
        efi.canTouchEfiVariables = true;
        systemd-boot = {
          enable = true;
          configurationLimit = 20;
          consoleMode = lib.mkDefault "max";
        };
      };
      plymouth = {
        enable = true;
        theme = "spinner";
      };
    };
    environment.systemPackages = with pkgs; [greetd.tuigreet];
  };
}
