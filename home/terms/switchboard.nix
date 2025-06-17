# ~/flake/home/terminals/my-module.nix
{
  config,
  lib,
  ...
}: {
  imports =
    # Conditionally import ghostty.nix based on config.custom.ghostty.enable
    lib.optional config.custom.ghostty.enable ./ghostty.nix;
  # If you later add kitty.nix, you'd do:
  # ++ lib.optional config.custom.kitty.enable ./kitty.nix;
}
