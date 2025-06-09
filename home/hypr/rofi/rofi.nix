{
  pkgs,
  config,
  ...
}: {
  programs = {
    rofi = {
      enable = true;
      package = pkgs.rofi-wayland;
      extraConfig = {
        modi = "drun,filebrowser,run";
        show-icons = true;
        icon-theme = "Papirus";
        location = 0;
        font = "JetBrainsMono Nerd Font Mono 12";
        drun-display-format = "{icon} {name}";
        display-drun = " Apps";
        display-run = " Run";
        display-filebrowser = " File";
      };
      theme = let
        inherit (config.lib.formats.rasi) mkLiteral;
        # Define your own color palette here!
        # You can use any hex color codes you prefer.
        # These are just example dark theme colors.
        myBg = "#282A36"; # Drakula's background
        myBgAlt = "#44475A"; # Drakula's current line/selection background
        myForeground = "#F8F8F2"; # Drakula's foreground
        mySelected = "#50FA7B"; # Drakula's green (for selected items)
        myActive = "#BD93F9"; # Drakula's purple (for active elements)
        myTextSelected = "#282A36"; # Text color for selected items (should contrast with mySelected)
        myTextColor = "#F8F8F2"; # General text color
        myBorderColor = "#FF79C6"; # Drakula's pink (for borders)
        myUrgent = "#FF5555"; # Drakula's red (for urgent elements)
      in {
        "*" = {
          # Use the new custom variables defined above
          bg = mkLiteral "${myBg}";
          bg-alt = mkLiteral "${myBgAlt}";
          foreground = mkLiteral "${myForeground}";
          selected = mkLiteral "${mySelected}";
          active = mkLiteral "${myActive}";
          text-selected = mkLiteral "${myTextSelected}";
          text-color = mkLiteral "${myTextColor}";
          border-color = mkLiteral "${myBorderColor}";
          urgent = mkLiteral "${myUrgent}";
        };
        "window" = {
          width = mkLiteral "50%";
          transparency = "real";
          orientation = mkLiteral "vertical";
          cursor = mkLiteral "default";
          spacing = mkLiteral "0px";
          border = mkLiteral "2px";
          border-color = "@border-color";
          border-radius = mkLiteral "20px";
          background-color = mkLiteral "@bg";
        };
        "mainbox" = {
          padding = mkLiteral "15px";
          enabled = true;
          orientation = mkLiteral "vertical";
          children = map mkLiteral [
            "inputbar"
            "listbox"
          ];
          background-color = mkLiteral "transparent";
        };
        "inputbar" = {
          enabled = true;
          padding = mkLiteral "10px 10px 200px 10px";
          margin = mkLiteral "10px";
          background-color = mkLiteral "transparent";
          border-radius = "25px";
          orientation = mkLiteral "horizontal";
          children = map mkLiteral [
            "entry"
            "dummy"
            "mode-switcher"
          ];
          background-image = mkLiteral ''url("~/Pictures/Wallpapers/Lofi-Cafe1.png", width)'';
        };
        "entry" = {
          enabled = true;
          expand = false;
          width = mkLiteral "20%";
          padding = mkLiteral "10px";
          border-radius = mkLiteral "12px";
          background-color = mkLiteral "@selected";
          text-color = mkLiteral "@text-selected";
          cursor = mkLiteral "text";
          placeholder = "🖥️ Search ";
          placeholder-color = mkLiteral "inherit";
        };
        "listbox" = {
          spacing = mkLiteral "10px";
          padding = mkLiteral "10px";
          background-color = mkLiteral "transparent";
          orientation = mkLiteral "vertical";
          children = map mkLiteral [
            "message"
            "listview"
          ];
        };
        "listview" = {
          enabled = true;
          columns = 2;
          lines = 6;
          cycle = true;
          dynamic = true;
          scrollbar = false;
          layout = mkLiteral "vertical";
          reverse = false;
          fixed-height = false;
          fixed-columns = true;
          spacing = mkLiteral "10px";
          background-color = mkLiteral "transparent";
          border = mkLiteral "0px";
        };
        "dummy" = {
          expand = true;
          background-color = mkLiteral "transparent";
        };
        "mode-switcher" = {
          enabled = true;
          spacing = mkLiteral "10px";
          background-color = mkLiteral "transparent";
        };
        "button" = {
          width = mkLiteral "5%";
          padding = mkLiteral "12px";
          border-radius = mkLiteral "12px";
          background-color = mkLiteral "@text-selected";
          text-color = mkLiteral "@text-color";
          cursor = mkLiteral "pointer";
        };
        "button selected" = {
          background-color = mkLiteral "@selected";
          text-color = mkLiteral "@text-selected";
        };
        "scrollbar" = {
          width = mkLiteral "4px";
          border = 0;
          handle-color = mkLiteral "@border-color";
          handle-width = mkLiteral "8px";
          padding = 0;
        };
        "element" = {
          enabled = true;
          spacing = mkLiteral "10px";
          padding = mkLiteral "10px";
          border-radius = mkLiteral "12px";
          background-color = mkLiteral "transparent";
          cursor = mkLiteral "pointer";
        };
        "element normal.normal" = {
          background-color = mkLiteral "inherit";
          text-color = mkLiteral "inherit";
        };
        "element normal.urgent" = {
          background-color = mkLiteral "@urgent";
          text-color = mkLiteral "@foreground";
        };
        "element normal.active" = {
          background-color = mkLiteral "@active";
          text-color = mkLiteral "@foreground";
        };
        "element selected.normal" = {
          background-color = mkLiteral "@selected";
          text-color = mkLiteral "@text-selected";
        };
        "element selected.urgent" = {
          background-color = mkLiteral "@urgent";
          text-color = mkLiteral "@text-selected";
        };
        "element selected.active" = {
          background-color = mkLiteral "@urgent";
          text-color = mkLiteral "@text-selected";
        };
        "element alternate.normal" = {
          background-color = mkLiteral "transparent";
          text-color = mkLiteral "inherit";
        };
        "element alternate.urgent" = {
          background-color = mkLiteral "transparent";
          text-color = mkLiteral "inherit";
        };
        "element alternate.active" = {
          background-color = mkLiteral "transparent";
          text-color = mkLiteral "inherit";
        };
        "element-icon" = {
          background-color = mkLiteral "transparent";
          text-color = mkLiteral "inherit";
          size = mkLiteral "36px";
          cursor = mkLiteral "inherit";
        };
        "element-text" = {
          background-color = mkLiteral "transparent";
          font = "JetBrainsMono Nerd Font Mono 12";
          text-color = mkLiteral "inherit";
          cursor = mkLiteral "inherit";
          vertical-align = mkLiteral "0.5";
          horizontal-align = mkLiteral "0.0";
        };
        "message" = {
          background-color = mkLiteral "transparent";
          border = mkLiteral "0px";
        };
        "textbox" = {
          padding = mkLiteral "12px";
          border-radius = mkLiteral "10px";
          background-color = mkLiteral "@bg-alt";
          text-color = mkLiteral "@bg";
          vertical-align = mkLiteral "0.5";
          horizontal-align = mkLiteral "0.0";
        };
        "error-message" = {
          padding = mkLiteral "12px";
          border-radius = mkLiteral "20px";
          background-color = mkLiteral "@bg-alt";
          text-color = mkLiteral "@bg";
        };
      };
    };
  };
}
