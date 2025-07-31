{ config, lib, pkgs, ... }:
{
  # Clean NetworkManager setup - no secrets in repo
  networking = {
    wireless.enable = false;  # Disable wpa_supplicant
    networkmanager = {
      enable = true;
      wifi.backend = "iwd";
      # Optional: enable connection sharing
      # connectionConfig = {
      #   "connection.permissions" = "user:cameron:;";
      # };
    };
  };
  
  # Add user to networkmanager group for GUI/CLI control
  users.users.cameron.extraGroups = [ "networkmanager" ];
  
  # Optional: Install GUI tools for easier network management
  environment.systemPackages = with pkgs; [
    networkmanagerapplet  # nm-applet for system tray
    # nmtui                # TUI interface (alternative to GUI)
  ];
  
  # Portal configuration (keeping your existing setup)
  services.dbus.enable = true;
  services.dbus.packages = with pkgs; [
    xdg-desktop-portal
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland
  ];
  
  services.upower.enable = true;
  
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
    config = {
      common = {
        default = ["hyprland"];
        "org.freedesktop.impl.portal.FileChooser" = ["gtk"];
      };
    };
  };
}
