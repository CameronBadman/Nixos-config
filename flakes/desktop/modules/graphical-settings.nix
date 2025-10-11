# flakes/desktop/modules/graphical-settings.nix
{ config, lib, pkgs, ... }: {
  wayland.windowManager.hyprland.settings = {
    env = [
      "NIXOS_OZONE_WL,1"
      "XCURSOR_SIZE,24"
      "WLR_RENDERER,gles2"
    ];
    
    monitor = [
      "eDP-1,disable"
      "HDMI-A-1,2560x1440@143.91,0x0,1"
      "DP-1,2560x1440@143.99,2560x0,1"
    ];
    
    misc = {
      disable_hyprland_logo = true;
      disable_splash_rendering = true;
      mouse_move_enables_dpms = true;
      vrr = 0;
      force_default_wallpaper = 0;
      vfr = true;
    };
    
    cursor = {
      no_hardware_cursors = true;
      min_refresh_rate = 60;
      hotspot_padding = 0;
      inactive_timeout = 0;
      hide_on_key_press = false;
      hide_on_touch = false;
      enable_hyprcursor = false;
      default_monitor = "HDMI-A-1";
    };
    
    input = {
      kb_layout = "us";
      kb_options = "caps:ctrl_modifier";
      follow_mouse = 1;
      accel_profile = "flat";
      sensitivity = 0;
      force_no_accel = true;
      
      touchpad = {
        natural_scroll = true;
        disable_while_typing = true;
        tap-to-click = true;
      };
    };
    
    device = [
      {
        name = "logitech-usb-receiver";
        sensitivity = 0;
        accel_profile = "flat";
      }
      {
        name = "keychron-k10-pro-mouse";
        sensitivity = 0;
        accel_profile = "flat";
      }
    ];
    
    general = {
      gaps_in = 5;
      gaps_out = 10;
      border_size = 2;
      "col.active_border" = "rgb(33ccff)";
      "col.inactive_border" = "rgb(595959)";
      layout = "dwindle";
      allow_tearing = false;
    };
    
    decoration = {
      rounding = 5;
    };
    
    animations = {
      enabled = true;
      animation = [
        "windows, 1, 7, default"
        "windowsOut, 1, 7, default, popin 80%"
        "border, 1, 10, default"
        "fade, 1, 7, default"
        "workspaces, 1, 6, default"
      ];
    };
    
    dwindle = {
      pseudotile = true;
      preserve_split = true;
    };
  };
}
