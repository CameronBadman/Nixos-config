# flakes/desktop/modules/keybinds.nix
{ config, lib, pkgs, ... }: {
  environment.etc."hypr/conf.d/keybinds.conf".text = ''
    # Set main modifier key
    $mainMod = SUPER

    # Basic window management
    bind = $mainMod, Q, exec, kitty
    bind = $mainMod, C, killactive,
    bind = $mainMod, M, exit,
    bind = $mainMod, E, exec, nautilus
    bind = $mainMod, V, togglefloating,
    bind = $mainMod, R, exec, rofi -show drun
    bind = $mainMod, P, pseudo
    bind = $mainMod, J, togglesplit

    # Move focus with arrow keys
    bind = $mainMod, left, movefocus, l
    bind = $mainMod, right, movefocus, r
    bind = $mainMod, up, movefocus, u
    bind = $mainMod, down, movefocus, d

    # Move focus with vim keys
    bind = $mainMod, H, movefocus, l
    bind = $mainMod, L, movefocus, r
    bind = $mainMod, K, movefocus, u
    bind = $mainMod, J, movefocus, d

    # Move windows
    bind = $mainMod SHIFT, left, movewindow, l
    bind = $mainMod SHIFT, right, movewindow, r
    bind = $mainMod SHIFT, up, movewindow, u
    bind = $mainMod SHIFT, down, movewindow, d

    # Resize windows
    bind = $mainMod CTRL, left, resizeactive, -20 0
    bind = $mainMod CTRL, right, resizeactive, 20 0
    bind = $mainMod CTRL, up, resizeactive, 0 -20
    bind = $mainMod CTRL, down, resizeactive, 0 20

    # Mouse bindings
    bindm = $mainMod, mouse:272, movewindow
    bindm = $mainMod, mouse:273, resizewindow

    # Screenshots
    bind = , Print, exec, grim -g "$(slurp)" - | wl-copy
    bind = $mainMod, Print, exec, grim - | wl-copy
    bind = $mainMod SHIFT, S, exec, grim -g "$(slurp)" ~/Pictures/Screenshots/$(date +'%Y-%m-%d_%H-%M-%S').png

    # Audio controls
    bind = , XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
    bind = , XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
    bind = , XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
    bind = , XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle

    # Brightness controls
    bind = , XF86MonBrightnessUp, exec, brightnessctl set 10%+
    bind = , XF86MonBrightnessDown, exec, brightnessctl set 10%-

    # Window management shortcuts
    bind = $mainMod, F, fullscreen
    bind = $mainMod, T, togglefloating
    bind = $mainMod SHIFT, T, pin

    # Special workspace for scratchpad
    bind = $mainMod, S, togglespecialworkspace, magic
    bind = $mainMod SHIFT, S, movetoworkspace, special:magic
  '';
}
