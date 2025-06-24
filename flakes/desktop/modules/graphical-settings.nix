# flakes/desktop/modules/graphical-settings.nix
{ config, lib, pkgs, ... }: {
  environment.etc."hypr/conf.d/graphical-settings.conf".text = ''
    # Environment variables for cursor and rendering
    env = WLR_NO_HARDWARE_CURSORS,1
    env = NIXOS_OZONE_WL,1
    env = WLR_DRM_NO_MODIFIERS,1
    env = XCURSOR_SIZE,24
    env = WLR_RENDERER,vulkan
    env = WLR_DRM_NO_ATOMIC,1

    # Monitor configuration
    monitor = eDP-1,disable
    monitor = HDMI-A-1,2560x1440@144,0x0,1
    monitor = DP-1,2560x1440@144,2560x0,1

    # Hyprland misc settings
    misc {
        disable_hyprland_logo = true
        disable_splash_rendering = true
        mouse_move_enables_dpms = true
        vrr = 0
        force_default_wallpaper = 0
        vfr = false
    }
    
    # Cursor configuration for multi-monitor
    cursor {
        no_hardware_cursors = true
        min_refresh_rate = 60
        hotspot_padding = 0
        inactive_timeout = 0
        hide_on_key_press = false
        hide_on_touch = false
        enable_hyprcursor = false
        default_monitor = HDMI-A-1
    }

    # Input configuration
    input {
        kb_layout = us
        follow_mouse = 1
        accel_profile = flat
        sensitivity = 0
        force_no_accel = true
        
        touchpad {
            natural_scroll = true
            disable_while_typing = true
            tap-to-click = true
        }
    }

    # Per-device configurations for external mice
    device {
        name = logitech-usb-receiver
        sensitivity = 0
        accel_profile = flat
    }

    device {
        name = keychron-k10-pro-mouse
        sensitivity = 0
        accel_profile = flat
    }

    # Window management
    general {
        gaps_in = 5
        gaps_out = 10
        border_size = 2
        col.active_border = rgb(33ccff)
        col.inactive_border = rgb(595959)
        layout = dwindle
        allow_tearing = false
    }

    # Decorations
    decoration {
        rounding = 5
    }

    # Animations
    animations {
        enabled = true
        animation = windows, 1, 7, default
        animation = windowsOut, 1, 7, default, popin 80%
        animation = border, 1, 10, default
        animation = fade, 1, 7, default
        animation = workspaces, 1, 6, default
    }

    # Layout
    dwindle {
        pseudotile = true
        preserve_split = true
    }
  '';
}
