# ~/flake/home/terms/default.nix (if only ghostty.nix is imported here)
{
  config,
  lib,
  ...
}: {
  imports =
    lib.optional config.custom.ghostty.enable ./ghostty.nix
    ++ lib.optional config.custom.kitty.enable ./kitty.nix;
}
