{ config, lib, pkgs, ... }:
{
  home-manager.users.cameron = { pkgs, ... }: {
    wayland.windowManager.hyprland.settings = {
      # Monitor configuration
      monitor = [
        "HDMI-A-1,2560x1440@144,2560x0,1"
        "DP-1,2560x1440@120,5120x0,1"
      ];

      # Workspace configuration
      workspace = [
        # Workspaces for HDMI-A-1
        "1, monitor:HDMI-A-1"
        "2, monitor:HDMI-A-1"
        "3, monitor:HDMI-A-1"
        "4, monitor:HDMI-A-1"
        "5, monitor:HDMI-A-1"
        
        # Workspaces for DP-1
        "6, monitor:DP-1"
        "7, monitor:DP-1"
        "8, monitor:DP-1"
        "9, monitor:DP-1"
        "10, monitor:DP-1"
      ];

      # Workspace keybindings
      bind = [
        # Switch workspaces on HDMI-A-1
        "SUPER, 1, workspace, 1"
        "SUPER, 2, workspace, 2"
        "SUPER, 3, workspace, 3"
        "SUPER, 4, workspace, 4"
        "SUPER, 5, workspace, 5"
        
        # Switch workspaces on DP-1
        "SUPER, 6, workspace, 6"
        "SUPER, 7, workspace, 7"
        "SUPER, 8, workspace, 8"
        "SUPER, 9, workspace, 9"
        "SUPER, 0, workspace, 10"

        # Move active window to workspace on HDMI-A-1
        "SUPER SHIFT, 1, movetoworkspace, 1"
        "SUPER SHIFT, 2, movetoworkspace, 2"
        "SUPER SHIFT, 3, movetoworkspace, 3"
        "SUPER SHIFT, 4, movetoworkspace, 4"
        "SUPER SHIFT, 5, movetoworkspace, 5"

        # Move active window to workspace on DP-1
        "SUPER SHIFT, 6, movetoworkspace, 6"
        "SUPER SHIFT, 7, movetoworkspace, 7"
        "SUPER SHIFT, 8, movetoworkspace, 8"
        "SUPER SHIFT, 9, movetoworkspace, 9"
        "SUPER SHIFT, 0, movetoworkspace, 10"

        # Scroll through existing workspaces
        "SUPER, mouse_down, workspace, e+1"
        "SUPER, mouse_up, workspace, e-1"
      ];
    };
  };
}

