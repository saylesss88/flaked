{
  pkgs,
  lib,
  config,
  # userVars,
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
        initialHashedPassword = "$6$hLxz1nh01PVcUQ6e$4o6tYrRxbRQQFRN3NSUMkPuwdRpOhNdp1s07TAYr2shcbdQUkYurHyk8Xp8FvjVPwr60N4NSPDmwUr6Nd5FD9.";
        extraGroups = [
          "networkmanager"
          "wheel"
          "libvirtd"
          "scanner"
          "lp"
          "root"
          "jr"
          "sudo"
        ];
        # shell = pkgs.zsh;
        shell = pkgs.nushell; # default shell
        ignoreShellProgramCheck = true;
        packages = with pkgs; [
          tealdeer
          zoxide
          mcfly
          tokei
          stow
        ];
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
