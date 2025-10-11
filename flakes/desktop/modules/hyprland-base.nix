# flakes/desktop/modules/hyprland-base.nix (UPDATED)
{ config, lib, pkgs, ... }: {
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd.enable = true;
    
    settings = {
      # Basic settings that will be overridden by other modules
      # This ensures Hyprland starts properly
    };
  };
  
  home.packages = with pkgs; [
    wl-clipboard
  ];
}
