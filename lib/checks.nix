{
  inputs,
  self,
  pkgs,
  system,
  host,
  username,
  userVars,
}: {
  # Formatter check
  formatCheck = pkgs.runCommand "format-check" {nativeBuildInputs = [pkgs.nixfmt-rfc-style];} ''
    nixfmt --check ${self}
    touch $out
  '';

  # Linting check with deadnix
  deadnixCheck = pkgs.runCommand "deadnix-check" {nativeBuildInputs = [pkgs.deadnix];} ''
    deadnix --fail ${self}
    touch $out
  '';

  # NixOS configuration build
  nixosConfig = self.nixosConfigurations.${host}.config.system.build.toplevel;

  # Home Manager configuration
  homeConfig =
    (inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = {
        inherit
          inputs
          username
          system
          host
          userVars
          ;
      };
      modules = [
        inputs.home-manager.nixosModules.home-manager
        ../hosts/${host}/home.nix
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "backup";
          home.stateVersion = "24.11";
        }
      ];
    }).activationPackage; # Changed from activationPackage to activation-package

  # Dev shell
  devShell = self.devShells.${system}.default;
}
