{
  lib,
  config,
  userVars,
  ...
}: let
  cfg = config.custom.nh;
in {
  options.custom.nh = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable the nh module";
    };
    flake = lib.mkOption {
      # Suggestion: Define flake as an option
      type = lib.types.str;
      default = userVars.flake;
      description = "Path to the flake.nix file.";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 4d --keep 5";
      inherit (cfg) flake; # Use the option here
    };
  };
}
