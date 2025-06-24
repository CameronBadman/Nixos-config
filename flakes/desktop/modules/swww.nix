# flakes/desktop/modules/swww.nix
{ config, lib, pkgs, ... }: {
  # Install swww for wallpaper management
  environment.systemPackages = with pkgs; [
    swww
  ];

  # Swww configuration and startup
  environment.etc."hypr/conf.d/swww.conf".text = ''
    # Initialize swww daemon and set wallpaper
    exec-once = swww init &
    exec-once = sleep 2 && swww img ~/Pictures/Wallpapers/default.jpg --transition-type wipe --transition-duration 2
    
    # Optional: Random wallpaper script
    # exec-once = sleep 5 && ~/scripts/random-wallpaper.sh
  '';

  # Create a basic wallpaper script
  environment.etc."scripts/random-wallpaper.sh" = {
    text = ''
      #!/bin/bash
      
      WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
      
      if [ ! -d "$WALLPAPER_DIR" ]; then
          echo "Wallpaper directory $WALLPAPER_DIR does not exist"
          exit 1
      fi
      
      # Get random wallpaper
      WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.webp" \) | shuf -n 1)
      
      if [ -n "$WALLPAPER" ]; then
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
