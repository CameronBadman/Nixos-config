# flakes/desktop/modules/swww.nix
{ config, lib, pkgs, ... }: {
  # Install swww for wallpaper management
  environment.systemPackages = with pkgs; [
    swww
  ];
  
  # Swww configuration and startup
  environment.etc."hypr/conf.d/swww.conf".text = ''
    # Initialize swww daemon (this starts swww-daemon internally)
    exec-once = swww-daemon &
    exec-once = sleep 3 && swww img ~/Pictures/Wallpapers/background_test.gif --transition-type wipe --transition-duration 2
    
    # Fallback to static wallpaper if GIF doesn't exist
    exec-once = sleep 4 && [ ! -f ~/Pictures/Wallpapers/background_test.gif ] && swww img ~/Pictures/Wallpapers/default.jpg --transition-type fade --transition-duration 1
    
    # Optional: Random wallpaper script keybind
    # bind = SUPER, W, exec, ~/scripts/random-wallpaper.sh
  '';
  
  # Create a wallpaper script that supports GIFs
  environment.etc."scripts/random-wallpaper.sh" = {
    text = ''
      #!/bin/bash
      
      WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
      
      if [ ! -d "$WALLPAPER_DIR" ]; then
          echo "Wallpaper directory $WALLPAPER_DIR does not exist"
          exit 1
      fi
      
      # Get random wallpaper (including GIFs)
      WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.webp" -o -name "*.gif" \) | shuf -n 1)
      
      if [ -n "$WALLPAPER" ]; then
          # Check if swww daemon is running
          if ! pgrep -x "swww-daemon" > /dev/null; then
              echo "Starting swww daemon..."
              swww-daemon &
              sleep 2
          fi
          
          swww img "$WALLPAPER" --transition-type wipe --transition-duration 2
          echo "Set wallpaper: $WALLPAPER"
      else
          echo "No wallpapers found in $WALLPAPER_DIR"
      fi
    '';
    mode = "0755";
  };
  
  # Create wallpaper directory structure
  systemd.tmpfiles.rules = [
    "d /home/cameron/Pictures 0755 cameron users -"
    "d /home/cameron/Pictures/Wallpapers 0755 cameron users -"
    "d /home/cameron/scripts 0755 cameron users -"
  ];
  
}
