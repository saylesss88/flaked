# ~/flake/options/custom-options.nix
{lib, ...}: {
  options.custom = {
    ghostty.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable the Ghostty terminal module.";
    };
  };
}
