{
  pkgs,
  inputs,
  ...
}: {
  # Home Manager Settings
  home = {
    username = "jr";
    homeDirectory = "/home/jr";
    stateVersion = "25.05";
  };
  programs.home-manager.enable = true;
  # programs.nix-index.enable = true;
  # Import Program Configurations
  imports = [
    # inputs.dont-track-me.homeManagerModules.default
    # inputs.nix-index-database.hmModules.nix-index
    # {programs.nix-index-database.comma.enable = true;}
    # ./ghostty.nix
    # ./hypr
    inputs.lib.homeModules
  ];

  home.pointerCursor = {
    enable = true;
    package = inputs.rose-pine-hyprcursor.packages.${pkgs.system}.default;
    name = "BreezeX-RosePine-Linux"; # Or the specific name of the theme as packaged
    size = 24; # Optional: Set the cursor size
  };

  # Custom home-manager modules
  custom = {
    hyprland.enable = true;
    wlogout.enable = true;
    helixModule.enable = true;
    ghostty.enable = true;
    kitty.enable = true;
    gitModule = {
      enable = true;
      # userName = "TSawyer87";
      # userEmail = "sawyerjr.25@gmail.com";

      userName = "saylesss88";
      userEmail = "saylesss87@proton.me";
      # aliases = "";
      # ignores = "";
      # packages = "";
    };
    # jjModule = {
    #   enable = true;
    # };
    nhModule = {
      enable = true;
      flake = "/home/jr/flake";
    };
    nvfModule.enable = true;
    batModule.enable = true;
    yaziModule.enable = true;
    # discord.enable = true;
  };

  # dont-track-me = {
  #   enable = true;
  #   enableAll = true;
  # };

  home.packages = with pkgs; [
    libnotify
    # ventoy
    gdb # Nix Debugger
  ];

  # Enable auto-mount
  services.udiskie.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # nixpkgs.config.allowUnfree = true;

  # Styling Options
  # stylix = {
  #   targets = {
  #     waybar.enable = false;
  #     rofi.enable = false;
  #     wofi.enable = false;
  #     mako.enable = false;
  #     hyprland.enable = false;
  #     hyprlock.enable = false;
  #     helix.enable = false;
  #     ghostty.enable = false;
  #     # zed.enable = false
  #     # nvf.enable = false
  #   };
  # };
}
