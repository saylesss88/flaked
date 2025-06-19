{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: {
  options = {
    custom.users.enable = lib.mkEnableOption "Enables users module";
  };

  config = lib.mkIf config.custom.users.enable {
    users.users = {
      # ${username} = {
      jr = {
        homeMode = "755";
        isNormalUser = true;
        # description = userVars.gitUsername;
        description = "saylesss88";
        hashedPasswordFile = config.sops.secrets.password_hash.path;
        extraGroups = [
          "networkmanager"
          "wheel"
          "libvirtd"
          "scanner"
          "lp"
          "root"
          "jr"
          "sudo"
          "git"
        ];
        # shell = pkgs.zsh;
        shell = pkgs.nushell; # default shell
        ignoreShellProgramCheck = true;
        packages = [
          inputs.home-manager.packages.${pkgs.system}.default
          pkgs.tealdeer
          pkgs.zoxide
          pkgs.mcfly
          pkgs.tokei
          pkgs.stow
        ];
      };
      users.users.git = {
        isSystemUser = true; # Often, dedicated service users like 'git' are system users
        group = "git"; # Assign to a dedicated 'git' group
        home = "/var/lib/git"; # Standard location for non-interactive service user homes
        createHome = true; # Make sure the home directory is created
        homeMode = "0700"; # Restrict permissions for security
        shell = "${pkgs.git}/bin/git-shell";
        # No extraGroups unless specifically needed for other service interactions
        # No packages unless this user needs specific tools
        # description = "Git service user for hosting repositories";
      };

      # "newuser" = {
      #   homeMode = "755";
      #   isNormalUser = true;
      #   description = "New user account";
      #   extraGroups = [ "networkmanager" "wheel" "libvirtd" ];
      #   shell = pkgs.bash;
      #   ignoreShellProgramCheck = true;
      #   packages = with pkgs; [];
      # };
    };
  };
}
