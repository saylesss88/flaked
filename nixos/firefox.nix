{
  config,
  pkgs,
  ...
}: {
  programs.firefox = {
    enable = true;
    profiles.default = {
      settings = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "sidebar.verticalTabs" = true;
      };
      userChrome = builtins.readFile ./userChrome.css;

      userContent = builtins.readFile ./userContent.css; # If you have userContent.css
    };
  };
}
