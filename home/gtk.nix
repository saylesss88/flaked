{
  pkgs,
  inputs,
  ...
}: {
  gtk = {
    enable = true;
    cursorTheme = {
      package = inputs.rose-pine-hyprcursor.packages.${pkgs.system}.default;
      name = "BreezeX-RosePine-Linux"; # Adjust if the actual theme name is different
      size = 24; # Optional
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };
}
