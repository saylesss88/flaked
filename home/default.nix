{
  lib,
  config,
  ...
}: {
  imports = [
    ./hypr
    ./terms
    ./shells
    ./helix
    # ./yazi.nix
    ./git.nix
    ./nh.nix
    ./gtk.nix
    ./packages.nix
    ./fd.nix
    ./nvf.nix
    ./bat.nix
    ./direnv.nix
    ./editorconfig.nix
    ./emoji.nix
  ];

  options.custom.magic.hm = {
    enable = lib.mkEnableOption "Enable Custom Home-Manager Modules Globally";
  };

  config = {
    custom.magic.home-manager.enable = lib.mkDefault false;
    home.stateVersion = "25.05";
  };
}
