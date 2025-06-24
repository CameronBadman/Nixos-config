# flakes/desktop/modules/workspaces.nix
{ config, lib, pkgs, ... }: {
  environment.etc."hypr/conf.d/workspaces.conf".text = ''
    # Workspace bindings
    bind = $mainMod, 1, workspace, 1
    bind = $mainMod, 2, workspace, 2
    bind = $mainMod, 3, workspace, 3
    bind = $mainMod, 4, workspace, 4
    bind = $mainMod, 5, workspace, 5
    bind = $mainMod, 6, workspace, 6
    bind = $mainMod, 7, workspace, 7
    bind = $mainMod, 8, workspace, 8
    bind = $mainMod, 9, workspace, 9
    bind = $mainMod, 0, workspace, 10

    # Move windows to workspaces
    bind = $mainMod SHIFT, 1, movetoworkspace, 1
    bind = $mainMod SHIFT, 2, movetoworkspace, 2
    bind = $mainMod SHIFT, 3, movetoworkspace, 3
    bind = $mainMod SHIFT, 4, movetoworkspace, 4
    bind = $mainMod SHIFT, 5, movetoworkspace, 5
    bind = $mainMod SHIFT, 6, movetoworkspace, 6
    bind = $mainMod SHIFT, 7, movetoworkspace, 7
    bind = $mainMod SHIFT, 8, movetoworkspace, 8
    bind = $mainMod SHIFT, 9, movetoworkspace, 9
    bind = $mainMod SHIFT, 0, movetoworkspace, 10

    # Move windows to workspaces silently
    bind = $mainMod CTRL, 1, movetoworkspacesilent, 1
    bind = $mainMod CTRL, 2, movetoworkspacesilent, 2
    bind = $mainMod CTRL, 3, movetoworkspacesilent, 3
    bind = $mainMod CTRL, 4, movetoworkspacesilent, 4
    bind = $mainMod CTRL, 5, movetoworkspacesilent, 5
    bind = $mainMod CTRL, 6, movetoworkspacesilent, 6
    bind = $mainMod CTRL, 7, movetoworkspacesilent, 7
    bind = $mainMod CTRL, 8, movetoworkspacesilent, 8
    bind = $mainMod CTRL, 9, movetoworkspacesilent, 9
    bind = $mainMod CTRL, 0, movetoworkspacesilent, 10

    # Scroll through existing workspaces
    bind = $mainMod, mouse_down, workspace, e+1
    bind = $mainMod, mouse_up, workspace, e-1

    # Workspace rules for specific monitors - HDMI gets 1-5, DP gets 6-10
    workspace = 1, monitor:HDMI-A-1, default:true
    workspace = 2, monitor:HDMI-A-1
    workspace = 3, monitor:HDMI-A-1
    workspace = 4, monitor:HDMI-A-1
    workspace = 5, monitor:HDMI-A-1
    workspace = 6, monitor:DP-1, default:true
    workspace = 7, monitor:DP-1
    workspace = 8, monitor:DP-1
    workspace = 9, monitor:DP-1
    workspace = 10, monitor:DP-1
  '';
}
