{
  config,
  pkgs,
  ...
}: {
  programs.firefox = {
    enable = true;
    profiles.default = {
      id = 0;
      name = "Default";
      settings = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "sidebar.verticalTabs" = true;
      };
      userChrome = builtins.readFile ../../.mozilla/firefox/8mab0vsl.default/chrome/MiniSthetic_Firefox/userChrome.css;

      userContent = builtins.readFile ../../.mozilla/firefox/8mab0vsl.default/chrome/MiniSthetic_Firefox/userContent.css; # If you have userContent.css
    };
  };
}
