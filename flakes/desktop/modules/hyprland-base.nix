# flakes/desktop/modules/hyprland-base.nix
{ config, lib, pkgs, ... }: {
  # Enable Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
  
  # Essential Wayland services
  services.dbus.enable = true;
  programs.dconf.enable = true;
  
  # Security for Wayland
  security.polkit.enable = true;
  security.rtkit.enable = true;
  
  # Auto-start polkit authentication agent
  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };
  
  # Display manager for Hyprland
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --cmd Hyprland";
        user = "greeter";
      };
    };
  };
  
  # XDG Portals for Hyprland
  services.dbus.packages = with pkgs; [
    xdg-desktop-portal
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland
  ];
  
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

  # Hyprland essentials
  environment.systemPackages = with pkgs; [
    polkit_gnome
    wl-clipboard
    vanilla-dmz
    numix-cursor-theme
  ];

  # Main Hyprland configuration file that sources all modules
  environment.etc."hypr/hyprland.conf".text = ''
    # Main Hyprland configuration file
    # This file sources all modular configuration files
    
    # Source all configuration modules
    source = /etc/hypr/conf.d/graphical-settings.conf
    source = /etc/hypr/conf.d/keybinds.conf
    source = /etc/hypr/conf.d/workspaces.conf
    source = /etc/hypr/conf.d/window-rules.conf
    source = /etc/hypr/conf.d/waybar.conf
    source = /etc/hypr/conf.d/dunst.conf
    source = /etc/hypr/conf.d/swww.conf
    
    # Any additional global settings can go here
  '';
}
