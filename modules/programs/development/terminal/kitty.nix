{ config, pkgs, lib, ... }:

{
  # Ensure kitty is installed
  environment.systemPackages = with pkgs; [
    kitty
  ];
  
  # Add backup file extension to home-manager
  home-manager.backupFileExtension = "backup";
  
  # Configure kitty using home-manager
  home-manager.users.cameron = { pkgs, ... }: {
    # Enable kitty with configuration
    programs.kitty = {
      enable = true;
      settings = {
        # Font settings
        font_family = "JetBrainsMono Nerd Font";
        font_size = "11.0";
        
        # Background and opacity
        background_opacity = "0.8";
        dynamic_background_opacity = "yes";
        
        # Window padding
        window_padding_width = "5";
        
        # Cursor settings
        cursor_shape = "block";
        cursor_blink_interval = "0.5";
        cursor_beam_thickness = "1.5";
        cursor_underline_thickness = "2.0";
        
        # Cursor trail effect!
        cursor_trail = "3";                # Number of trailing cursors
        cursor_trail_decay = "0.1 0.4";    # Decay rate of the trail
        
        # Scrollback
        scrollback_lines = "10000";
        
        # Colors - matching your Alacritty theme
        foreground = "#c5c8c6";
        background = "#1d1f21";
        
        # Normal colors
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
        
        # No tab bar
        tab_bar_style = "hidden";
      };
      
      keybindings = {
        # Split window keybindings (similar to WezTerm)
        "ctrl+shift+|" = "launch --location=vsplit";
        "ctrl+shift+_" = "launch --location=hsplit";
        
        # Navigate between windows
        "ctrl+shift+h" = "neighboring_window left";
        "ctrl+shift+l" = "neighboring_window right";
        "ctrl+shift+k" = "neighboring_window up";
        "ctrl+shift+j" = "neighboring_window down";
      };
    };

  };
}
