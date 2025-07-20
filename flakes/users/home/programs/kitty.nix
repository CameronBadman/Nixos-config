# home/programs/kitty.nix - Kitty terminal configuration
{ config, lib, pkts, ... }: {
  programs.kitty = {
    enable = true;
    
    settings = {
      # Font configuration
      font_family = "JetBrainsMono Nerd Font";
      bold_font = "auto";
      italic_font = "auto";
      bold_italic_font = "auto";
      font_size = "11.0";
      
      # Background and opacity - key features!
      background_opacity = "0.95";
      dynamic_background_opacity = "yes";
      
      # Window padding
      window_padding_width = "5";
      
      # Cursor settings with trail effect!
      cursor_shape = "block";
      cursor_blink_interval = "0.5";
      cursor_beam_thickness = "1.5";
      cursor_underline_thickness = "2.0";
      cursor_trail = "3";                # Number of trailing cursors
      cursor_trail_decay = "0.1 0.4";    # Decay rate of the trail
      
      # Scrollback
      scrollback_lines = "10000";
      
      # Mouse
      mouse_hide_wait = "3.0";
      copy_on_select = true;
      
      # Terminal bell
      enable_audio_bell = false;
      visual_bell_duration = "0.1";
      
      # Window layout
      remember_window_size = true;
      initial_window_width = 1200;
      initial_window_height = 800;
      confirm_os_window_close = 0;
      
      # Performance
      repaint_delay = 10;
      input_delay = 3;
      sync_to_monitor = true;
      
      # Wayland support
      wayland_titlebar_color = "system";
      linux_display_server = "wayland";
      
      # No tab bar (cleaner look)
      tab_bar_style = "hidden";
      
      # Muted color scheme - much better than bright Kanagawa
      foreground = "#c5c8c6";
      background = "#1d1f21";
      
      # Normal colors - desaturated and pleasant
      color0 = "#1d1f21";  # black
      color1 = "#cc6666";  # red
      color2 = "#b5bd68";  # green
      color3 = "#f0c674";  # yellow
      color4 = "#81a2be";  # blue
      color5 = "#b294bb";  # magenta
      color6 = "#8abeb7";  # cyan
      color7 = "#c5c8c6";  # white
      
      # Bright colors
      color8 = "#666666";   # bright black
      color9 = "#d54e53";   # bright red
      color10 = "#b9ca4a";  # bright green
      color11 = "#e7c547";  # bright yellow
      color12 = "#7aa6da";  # bright blue
      color13 = "#c397d8";  # bright magenta
      color14 = "#70c0b1";  # bright cyan
      color15 = "#eaeaea";  # bright white
      
      # URL color
      url_color = "#7aa6da";
    };
    
    # Key bindings - including your window splitting
    keybindings = {
      # Clipboard
      "ctrl+shift+c" = "copy_to_clipboard";
      "ctrl+shift+v" = "paste_from_clipboard";
      
      # Font size
      "ctrl+plus" = "increase_font_size";
      "ctrl+minus" = "decrease_font_size";
      "ctrl+0" = "restore_font_size";
      
      # Scrolling
      "ctrl+shift+up" = "scroll_line_up";
      "ctrl+shift+down" = "scroll_line_down";
      "ctrl+shift+page_up" = "scroll_page_up";
      "ctrl+shift+page_down" = "scroll_page_down";
      
      # Window splitting (like your config)
      "ctrl+shift+|" = "launch --location=vsplit";
      "ctrl+shift+_" = "launch --location=hsplit";
      
      # Navigate between windows
      "ctrl+shift+h" = "neighboring_window left";
      "ctrl+shift+l" = "neighboring_window right";
      "ctrl+shift+k" = "neighboring_window up";
      "ctrl+shift+j" = "neighboring_window down";
    };
    
    # Shell integration
    shellIntegration.enableBashIntegration = true;
  };
}
