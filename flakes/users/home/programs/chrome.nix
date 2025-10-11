{ config, lib, pkgs, ... }: {
  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };
  
  xdg.desktopEntries.google-chrome-custom = {
    name = "Google Chrome (Custom)";
    genericName = "Web Browser";
    exec = "google-chrome-stable --enable-features=UseOzonePlatform --ozone-platform=wayland --gtk-version=4 --use-gl=egl --disable-features=UseSkiaRenderer --ignore-gpu-blocklist";
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
