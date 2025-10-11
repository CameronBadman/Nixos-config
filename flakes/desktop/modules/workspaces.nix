# flakes/desktop/modules/workspaces.nix
{ config, lib, pkgs, ... }: {
  wayland.windowManager.hyprland.settings = {
    bind = [
      "$mainMod, 1, workspace, 1"
      "$mainMod, 2, workspace, 2"
      "$mainMod, 3, workspace, 3"
      "$mainMod, 4, workspace, 4"
      "$mainMod, 5, workspace, 5"
      "$mainMod, 6, workspace, 6"
      "$mainMod, 7, workspace, 7"
      "$mainMod, 8, workspace, 8"
      "$mainMod, 9, workspace, 9"
      "$mainMod, 0, workspace, 10"
      
      "$mainMod SHIFT, 1, movetoworkspace, 1"
      "$mainMod SHIFT, 2, movetoworkspace, 2"
      "$mainMod SHIFT, 3, movetoworkspace, 3"
      "$mainMod SHIFT, 4, movetoworkspace, 4"
      "$mainMod SHIFT, 5, movetoworkspace, 5"
      "$mainMod SHIFT, 6, movetoworkspace, 6"
      "$mainMod SHIFT, 7, movetoworkspace, 7"
      "$mainMod SHIFT, 8, movetoworkspace, 8"
      "$mainMod SHIFT, 9, movetoworkspace, 9"
      "$mainMod SHIFT, 0, movetoworkspace, 10"
      
      "$mainMod CTRL, 1, movetoworkspacesilent, 1"
      "$mainMod CTRL, 2, movetoworkspacesilent, 2"
      "$mainMod CTRL, 3, movetoworkspacesilent, 3"
      "$mainMod CTRL, 4, movetoworkspacesilent, 4"
      "$mainMod CTRL, 5, movetoworkspacesilent, 5"
      "$mainMod CTRL, 6, movetoworkspacesilent, 6"
      "$mainMod CTRL, 7, movetoworkspacesilent, 7"
      "$mainMod CTRL, 8, movetoworkspacesilent, 8"
      "$mainMod CTRL, 9, movetoworkspacesilent, 9"
      "$mainMod CTRL, 0, movetoworkspacesilent, 10"
      
      "$mainMod, mouse_down, workspace, e+1"
      "$mainMod, mouse_up, workspace, e-1"
    ];
    
    workspace = [
      "1, monitor:HDMI-A-1, default:true"
      "2, monitor:HDMI-A-1"
      "3, monitor:HDMI-A-1"
      "4, monitor:HDMI-A-1"
      "5, monitor:HDMI-A-1"
      "6, monitor:DP-1, default:true"
      "7, monitor:DP-1"
      "8, monitor:DP-1"
      "9, monitor:DP-1"
      "10, monitor:DP-1"
    ];
  };
}
