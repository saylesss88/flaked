{
  pkgs,
  inputs,
  ...
}: {
  home.pointerCursor = {
    enable = true;
    package = inputs.rose-pine-hyprcursor.packages.${pkgs.system}.default;
    name = "BreezeX-RosePine-Linux"; # Or the specific name of the theme as packaged
    size = 24; # Optional: Set the cursor size
  };

  gtk = {
    enable = true;

    theme = {
      package = pkgs.flat-remix-gtk;
      name = "Flat-Remix-GTK-Grey-Darkest";
    };

    iconTheme = {
      package = pkgs.Tela-circle-dracula;
      name = "Tela-dracula-icon-theme";
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
  };
}
