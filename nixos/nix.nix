{
  lib,
  config,
  ...
}: let
  cfg = config.custom.nix;
in {
  options.custom.nix = {
    enable = lib.mkEnableOption "Enable the Nix Module";
  };

  config = lib.mkIf cfg.enable {
    nix = {
      settings.trusted-users = ["root" "jr"];
      # channel.enable = false;
      settings = {
        auto-optimise-store = true;
        experimental-features = [
          "nix-command"
          "flakes"
          "pipe-operators"
        ];
        # Number of simultaneous derivation builds
        # "auto" = optimal #
        max-jobs = lib.mkDefault "auto";

        # Number of cores per derivation build
        cores = lib.mkDefault 0; # 0 means "use all available cores"
      };
      registry = {
        # self = this flake
        # self.flake = inputs.self;
        # registers your nixpkgs flake input to `nixpkgs`
        # nix search nixpkgs#hello
        # nixpkgs.flake = inputs.nixpkgs;
      };
      # gc = {
      #   automatic = true;
      #   dates = "weekly";
      #   options = "--delete-older-than 4d";
      # };
    };
  };
}
