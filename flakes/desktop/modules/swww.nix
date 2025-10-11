# flakes/desktop/modules/swww.nix
{ config, lib, pkgs, ... }: {
  home.packages = with pkgs; [
    swww
  ];
  
  wayland.windowManager.hyprland.settings = {
    exec-once = [
      "swww-daemon"
    ];
  };
  
  home.file.".local/bin/random-wallpaper" = {
    executable = true;
    text = ''
      #!/bin/bash
      
      WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
      
      if [ ! -d "$WALLPAPER_DIR" ]; then
          echo "Wallpaper directory $WALLPAPER_DIR does not exist"
          exit 1
      fi
      
      WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.webp" -o -name "*.gif" \) | shuf -n 1)
      
      if [ -n "$WALLPAPER" ]; then
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
  };
  
  home.activation.createWallpaperDirs = lib.hm.dag.entryAfter ["writeBoundary"] ''
    mkdir -p $HOME/Pictures/Wallpapers
  '';
}
