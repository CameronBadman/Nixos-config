# flakes/desktop/modules/dunst.nix
{ config, lib, pkgs, ... }: {
  # Install dunst and libnotify
  environment.systemPackages = with pkgs; [
    dunst
    libnotify
  ];

  # Launch dunst
  environment.etc."hypr/conf.d/dunst.conf".text = ''
    exec-once = dunst &
  '';

  # Dunst configuration
  environment.etc."xdg/dunst/dunstrc".text = ''
    [global]
        monitor = 0
        follow = mouse
        width = 300
        height = 300
        origin = top-right
        offset = 10x50
        scale = 0
        notification_limit = 0
        
        progress_bar = true
        progress_bar_height = 10
        progress_bar_frame_width = 1
        progress_bar_min_width = 150
        progress_bar_max_width = 300
        
        indicate_hidden = yes
        shrink = no
        transparency = 0
        separator_height = 2
        padding = 8
        horizontal_padding = 8
        text_icon_padding = 0
        frame_width = 2
        frame_color = "#33ccff"
        separator_color = frame
        
        sort = yes
        idle_threshold = 120
        
        font = FiraCode Nerd Font 10
        line_height = 0
        markup = full
        format = "<b>%s</b>\n%b"
        alignment = left
        vertical_alignment = center
        show_age_threshold = 60
        word_wrap = yes
        ellipsize = middle
        ignore_newline = no
        stack_duplicates = true
        hide_duplicate_count = false
        show_indicators = yes
        
        icon_position = left
        min_icon_size = 0
        max_icon_size = 32
        icon_path = /usr/share/icons/gnome/16x16/status/:/usr/share/icons/gnome/16x16/devices/
        
        sticky_history = yes
        history_length = 20
        
        browser = /run/current-system/sw/bin/firefox -new-tab
        
        always_run_script = true
        title = Dunst
        class = Dunst
        corner_radius = 5
        ignore_dbusclose = false
        
        force_xwayland = false
        force_xinerama = false
        
        mouse_left_click = close_current
        mouse_middle_click = do_action, close_current
        mouse_right_click = close_all

    [experimental]
        per_monitor_dpi = false

    [urgency_low]
        background = "#1e1e2e"
        foreground = "#cdd6f4"
        timeout = 10

    [urgency_normal]
        background = "#1e1e2e"
        foreground = "#cdd6f4"
        timeout = 10

    [urgency_critical]
        background = "#1e1e2e"
        foreground = "#f38ba8"
        frame_color = "#f38ba8"
        timeout = 0

    [fullscreen_delay_everything]
        fullscreen = delay
    [fullscreen_show_critical]
        msg_urgency = critical
        fullscreen = show
  '';
}
