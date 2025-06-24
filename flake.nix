{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    impermanence.url = "github:nix-community/impermanence";
    disko.url = "github:nix-community/disko";
    hyprland.url = "github:hyprwm/Hyprland";
    helix.url = "github:helix-editor/helix";
    rose-pine-hyprcursor.url = "github:ndom91/rose-pine-hyprcursor";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    nvf.url = "github:notashelf/nvf";
    yazi.url = "github:sxyazi/yazi";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    devour-flake.url = "github:srid/devour-flake";
    devour-flake.flake = false;
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    wallpapers = {
      url = "github:saylesss88/wallpapers";
      flake = false;
    };
  };

  outputs = my-inputs @ {
    self,
    nixpkgs,
    treefmt-nix,
    ...
  }: let
    system = "x86_64-linux";
    host = "magic";
    colorscheme = "tokyonight_night";
    userVars = {
      username = "jr";
      gitEmail = "saylesss87@proton.me";
      gitUsername = "saylesss88";
      # gitEmail = "sawyerjr.25@gmail.com";
      # gitUsername = "TSawyer87";
      editor = "hx";
      term = "ghostty";
      keys = "us";
      browser = "firefox";
      flake = builtins.getEnv "HOME" + "/flaked";
    };

    inputs =
      my-inputs
      // {
        pkgs = import inputs.nixpkgs {
          inherit system;
        };
        lib = {
          overlays = import ./lib/overlay.nix;
          nixOsModules = import ./nixos;
          homeModules = import ./home;
          myLib = import ./lib/default.nix {inherit (nixpkgs) lib;};
          inherit system;
        };
      };
    # Define pkgs with allowUnfree
    pkgs = import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };

    # Use nixpkgs.lib directly
    inherit (nixpkgs) lib;

    # Formatter configuration
    treefmtEval = treefmt-nix.lib.evalModule pkgs ./lib/treefmt.nix;
  in {
    formatter.${system} = treefmtEval.config.build.wrapper;

    # # Style check for CI
    checks.${system}.style = treefmtEval.config.build.check self;

    # Development shell
    devShells.${system}.default = import ./lib/dev-shell.nix {
      inherit inputs;
    };

    nixosConfigurations.${host} = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit inputs system host userVars colorscheme;
        inherit (inputs.lib) myLib;
      };
      modules = [
        ./hosts/${host}/configuration.nix
        inputs.disko.nixosModules.disko
        inputs.home-manager.nixosModules.home-manager
        inputs.impermanence.nixosModules.impermanence
        (_: {
          # provides rev from `nixos-version --json`
          system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;
        })
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "backup";
          home-manager.users.jr = ./hosts/magic/home.nix;
          home-manager.extraSpecialArgs = {
            inherit inputs;
            inherit (inputs.lib) myLib;
          };
        }
      ];
    };
  };
}
