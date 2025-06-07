{...}: {
  imports = [
    ./hypr
    ./terms/switchboard.nix
    ../options/custom-options.nix
    ./terms/kitty.nix
    ./shells
    ./helix
    ./yazi.nix
    ./git.nix
    ./nh.nix
    ./gtk.nix
    ./packages.nix
    ./fd.nix
    ./nvf.nix
    ./bat.nix
  ];
}
