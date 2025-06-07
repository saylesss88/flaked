{...}: {
  imports = [
    ./networking.nix
    ./greetd.nix
    ./drivers
    ./fonts.nix
    ./boot.nix
    ./nix.nix
    ./cachix.nix
    ./bluetooth.nix
    ./programs.nix
    ./thunar.nix
    ./keyd.nix
    ./lsp.nix
    ./environmentVariables.nix
    ./pipewire.nix
    ./zram.nix
    ./utils.nix
  ];
}
