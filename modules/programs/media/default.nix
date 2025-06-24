{ config, pkgs, lib, ... }:
{
  environment.systemPackages = with pkgs; [
    xdg-desktop-portal
    xdg-desktop-portal-wlr
    xdg-desktop-portal-gtk
    xdg-utils
    google-chrome
    vesktop
    playerctl
    pavucontrol
    blueman
    bluetuith
    zoom-us
    wireplumber
    spotify
    webcord
    (import ./cider.nix { inherit pkgs lib; })
    
  ];
  
  # Set environment variables for better Firefox Wayland support
  environment.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
    MOZ_USE_XINPUT2 = "1";
  };
  
  # Create a Firefox configuration file
  environment.etc."firefox/policies/policies.json" = {
    text = builtins.toJSON {
      policies = {
        DisableFirefoxStudies = true;
        DisableTelemetry = true;
        OverrideFirstRunPage = "";
        UserMessaging = {
          WhatsNew = false;
          ExtensionRecommendations = false;
          FeatureRecommendations = false;
        };
      };
    };
    mode = "0644";
  };
}
