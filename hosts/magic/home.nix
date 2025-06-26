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
    inputs.impermanence.homeManagerModules.impermanence
  ];

  home.persistence."/persist/home/jr" = {
    # Matches system-level /persist/home/jr
    directories = [
      ".mozilla/firefox"
      # ... other user-specific directories
    ];
    allowOther = false;
  };

  # Custom home-manager modules
  custom = {
    magic.hm.enable = true;
    hyprland.enable = true;
    wlogout.enable = true;
    helix.enable = true;
    ghostty.enable = true;
    kitty.enable = true;
    git = {
      enable = true;
      userName = "saylesss88";
      userEmail = "saylesss87@proton.me";
      # aliases = "";
      # ignores = "";
      # packages = "";
    };
    # jjModule = {
    #   enable = true;
    # };
    nh = {
      enable = true;
      flake = "/home/jr/flaked";
    };
    nvf.enable = false;
    bat.enable = true;
    yazi.enable = true;
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
