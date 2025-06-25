# home/programs/chrome.nix - Chrome configuration (minimal since it's not declarative)
{ config, lib, pkgs, ... }: {
  # Chrome doesn't have declarative config like Firefox in home-manager
  # Just ensuring it's available and setting some environment variables
  
  home.sessionVariables = {
    # Force Wayland for Chrome
    NIXOS_OZONE_WL = "1";
  };
  
  # You can create a desktop entry with preferred flags if needed
  xdg.desktopEntries.google-chrome-custom = {
    name = "Google Chrome (Custom)";
    genericName = "Web Browser";
    exec = "google-chrome-stable --enable-features=UseOzonePlatform --ozone-platform=wayland --gtk-version=4";
    icon = "google-chrome";
    categories = [ "Network" "WebBrowser" ];
    mimeType = [
      "text/html"
      "text/xml"
      "application/xhtml+xml"
      "x-scheme-handler/http"
      "x-scheme-handler/https"
    ];
  };
}
