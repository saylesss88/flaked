{...}: {
  imports = [
    ./kitty.nix
    ./ghostty.nix
  ];
}
# {
#   imports =
#     lib.optional config.custom.ghostty.enable ./ghostty.nix
#     ++ lib.optional config.custom.kitty.enable ./kitty.nix;
# }

