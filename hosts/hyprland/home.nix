{ config, lib, pkgs, inputs, ... }: {
  imports = [ ./config ];
  
  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    settings = {
      monitor = [ ",preferred,auto,1" ];
      
      exec-once = [
        "swww-daemon"
        "swww img --transition-fps 144 --transition-type any --transition-duration 1 ~/.config/hypr/wallpapers/back1.gif"
        "dunst"
        "waybar"
      ];

      "$terminal" = "${pkgs.alacritty}/bin/alacritty";
      "$fileManager" = "dolphin";
      "$menu" = "wofi --show drun";

      env = [
        "XCURSOR_SIZE,24"
        "QT_QPA_PLATFORMTHEME,qt5ct"
      ];

      input = {
        kb_layout = "us";
        kb_options = "ctrl:swapcaps";
        follow_mouse = 1;
        touchpad = { natural_scroll = true; };
        sensitivity = 0;
      };

      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
        layout = "dwindle";
      };

      decoration = {
        rounding = 10;
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
        };
      };

      animations = {
        enabled = true;
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      gestures = { workspace_swipe = true; };
      
      misc = { force_default_wallpaper = 0; };
    };
  };

  home.packages = with pkgs; [ swww ];
}
