{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    # Enabled with custom.users.enable = true; in `configuration.nix`
    custom.users.enable = lib.mkEnableOption "Enables users module";
  };

  config = lib.mkIf config.custom.users.enable {
    users.users = {
      # Change me!
      jr = {
        homeMode = "755";
        isNormalUser = true;
        # Change me!
        description = "saylesss88";
        # Change me! generate with `mkpasswd -m SHA-512 -s`
        # initialHashedPassword = "$6$knQSQp4le3uiy..3$gAUAugTxAeHUpWKf6iwo.omaLvm0j5xBXdzhmfFpBQKQRfmioQ1dDbjWNZRTtjbJ4X0PIjkIQOCcLcimOJe4Y0";
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
        ];
        shell = pkgs.nushell;
        ignoreShellProgramCheck = true;
        packages = [
          pkgs.tealdeer
          pkgs.zoxide
          pkgs.mcfly
          pkgs.tokei
          pkgs.stow
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
