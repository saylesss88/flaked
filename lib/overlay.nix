_final: prev: let
  # Helper function to import a package
  callPackage = prev.lib.callPackageWith (prev // packages);

  # Define all packages
  packages = {
    # Additional packages
    pokego = callPackage ./pac_defs/pokego.nix {};
    pokemon-colorscripts = callPackage ./pac_defs/pokemon-colorscripts.nix {};
    python-pyamdgpuinfo = callPackage ./pac_defs/python-pyamdgpuinfo.nix {};
    Tela-circle-dracula = callPackage ./pac_defs/Tela-circle-dracula.nix {};
    Bibata-Modern-Ice = callPackage ./pac_defs/Bibata-Modern-Ice.nix {};
  };
in
  packages
