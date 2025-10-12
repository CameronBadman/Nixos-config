# flakes/desktop/modules/keybinds.nix
{ config, lib, pkgs, ... }: {
  wayland.windowManager.hyprland.settings = {
    "$mainMod" = "SUPER";
    
    bind = [
      "$mainMod, Q, exec, kitty"
      "$mainMod, W, killactive,"
      "$mainMod, M, exit,"
      "$mainMod, E, exec, nautilus"
      "$mainMod, V, togglefloating,"
      "$mainMod, P, pseudo"
      "$mainMod, J, togglesplit"
      
      "$mainMod, left, movefocus, l"
      "$mainMod, right, movefocus, r"
      "$mainMod, up, movefocus, u"
      "$mainMod, down, movefocus, d"
      
      "$mainMod, H, movefocus, l"
      "$mainMod, L, movefocus, r"
      "$mainMod, K, movefocus, u"
      "$mainMod, J, movefocus, d"
      
      "$mainMod SHIFT, left, movewindow, l"
      "$mainMod SHIFT, right, movewindow, r"
      "$mainMod SHIFT, up, movewindow, u"
      "$mainMod SHIFT, down, movewindow, d"
      
      "$mainMod CTRL, left, resizeactive, -20 0"
      "$mainMod CTRL, right, resizeactive, 20 0"
      "$mainMod CTRL, up, resizeactive, 0 -20"
      "$mainMod CTRL, down, resizeactive, 0 20"
      
      ", Print, exec, grim -g \"$(slurp)\" - | wl-copy"
      "$mainMod, Print, exec, grim - | wl-copy"
      "$mainMod SHIFT, S, exec, grim -g \"$(slurp)\" ~/Pictures/Screenshots/$(date +'%Y-%m-%d_%H-%M-%S').png"
      
      ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
      ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
      ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
      
      ", XF86MonBrightnessUp, exec, brightnessctl set 10%+"
      ", XF86MonBrightnessDown, exec, brightnessctl set 10%-"
      
      "$mainMod, F, fullscreen"
      "$mainMod, T, togglefloating"
      "$mainMod SHIFT, T, pin"
      
      "$mainMod, S, togglespecialworkspace, magic"
      "$mainMod SHIFT, S, movetoworkspace, special:magic"
    ];
    
    bindm = [
      "$mainMod, mouse:272, movewindow"
      "$mainMod, mouse:273, resizewindow"
    ];
  };
}
