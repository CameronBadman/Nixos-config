{ config, pkgs, ... }: {
  environment.systemPackages = with pkgs; [ ghostty ];

  # Create user-specific configuration
  home-manager.users.cameron = { pkgs, ... }: {
    xdg.configFile."ghostty/config".text = ''
      background-opacity = 0.85

      # Primary colors
      background = #1d1f21
      foreground = #c5c8c6

      # Normal colors
      palette = 0=#1d1f21
      palette = 1=#cc6666
      palette = 2=#b5bd68
      palette = 3=#f0c674
      palette = 4=#81a2be
      palette = 5=#b294bb
      palette = 6=#8abeb7
      palette = 7=#c5c8c6

      # Bright colors
      palette = 8=#666666
      palette = 9=#d54e53
      palette = 10=#b9ca4a
      palette = 11=#e7c547
      palette = 12=#7aa6da
      palette = 13=#c397d8
      palette = 14=#70c0b1
      palette = 15=#eaeaea

      # Font settings
      font-family = "JetBrainsMono Nerd Font"
      font-size = 11

      # Padding
      window-padding-x = 5
      window-padding-y = 5
    '';
  };
}
