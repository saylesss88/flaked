{
  config,
  lib,
  ...
}: {
  imports = builtins.concatLists [
    (lib.optional config.ghostty ./ghostty.nix)
    (lib.optional config.kitty ./kitty.nix)
  ];
}
