{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: let
  cfg = config.custom.hyprland;
in {
  options.custom.hyprland = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable hyprland module";
    };
  };
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      # swww
      grim
      slurp
      wl-clipboard-rs
      cliphist
      swappy
      ydotool
      wpaperd
      wofi
      hyprpicker
      pavucontrol
      blueman
      # lxqt.lxqt-policykit
      brightnessctl
      polkit_gnome
      wlr-randr
      wtype
      rose-pine-cursor
      # nwg-look
      yad
      # gtk-engine-murrine
    ];
    systemd.user.targets.hyprland-session.Unit.Wants = ["xdg-desktop-autostart.target"];
    wayland.windowManager.hyprland = {
      enable = true;
      # package = null;
      # portalPackage = null;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage =
        inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
      xwayland = {
        enable = true;
        # hidpi = true;
      };
      systemd.enable = true;
      systemd.variables = ["--all"];
    };

    # services.mako = {
    #   enable = true;
    #   settings = {
    #     actions = true;
    #     anchor = "top-right";
    #     background-color = "#1F1F28"; # Kanagawa Dragon: Sumi Ink 0
    #     border-color = "#7E7C81"; # Kanagawa Dragon: Gray
    #     # background-color = "#000000";
    #     # border-color = "#FFFFFF";
    #     border-radius = 10;
    #     default-timeout = 10000;
    #     font = "monospace 10";
    #     height = 100;
    #     width = 300;
    #     icons = true;
    #     ignore-timeout = false;
    #     layer = "top";
    #     margin = 10;
    #     markup = true;
    #   };
    # };
    # Place Files Inside Home Directory
    home.file = {
      "Pictures/Wallpapers" = {
        source = inputs.wallpapers;
        recursive = true;
      };
      ".face.icon".source = ./face.png;
      ".config/face.png".source = ./face.png;
      ".config/swappy/config".text = ''
        [Default]
        save_dir=/home/jr/Pictures/Screenshots
        save_filename_format=swappy-%Y%m%d-%H%M%S.png
        show_panel=false
        line_size=5
        text_size=20
        text_font=Ubuntu
        paint_mode=brush
        early_exit=true
        fill_shape=false
      '';
      ".config/wpaperd/config.toml".text = ''
        [default]
         path = "/home/jr/Pictures/Wallpapers/"
         duration = "30m"
         transition-time = 600
      '';
    };
  };
}
