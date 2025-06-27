{
  lib,
  config,
  pkgs,
  # userVars ? {},
  ...
}: let
  cfg = config.custom.jj;
in {
  options.custom.jj = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable the Jujutsu (jj) module";
    };

    userName = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      # default = userVars.gitUsername; # or "TSawyer87"; # Fallback to "TSawyer87" if userVars.gitUsername is undefined
      default = "saylesss88";
      description = "Jujutsu user name";
    };

    userEmail = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      # default = userVars.gitEmail; # or "sawyerjr.25@gmail.com"; # Fallback to email if userVars.gitEmail is undefined
      default = "saylesss87@proton.me";
      description = "Jujutsu user email";
    };

    configFile = lib.mkOption {
      type = lib.types.lines;
      default = ''
        [ui]
        diff-editor = ["nvim", "-c", "DiffEditor $left $right $output"]
      '';
      description = "Content of the Jujutsu config.toml file";
    };

    packages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = with pkgs; [lazyjj meld];
      description = "Additional Jujutsu-related packages to install";
    };

    settings = lib.mkOption {
      type = lib.types.attrs;
      default = {
        ui = {
          default-command = ["status" "--no-pager"];
          diff-editor = ":builtin";
          merge-editor = ":builtin";
        };
      };
      description = "Jujutsu configuration settings";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = cfg.packages;

    home.file.".jj/config.toml".text = cfg.configFile;

    programs.jujutsu = {
      enable = true;
      settings = lib.mergeAttrs cfg.settings {
        user = {
          name = cfg.userName;
          email = cfg.userEmail;
        };
      };
    };
  };
}
