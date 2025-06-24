# flakes/desktop/modules/window-rules.nix
{ config, lib, pkgs, ... }: {
  environment.etc."hypr/conf.d/window-rules.conf".text = ''
    # Float specific applications
    windowrulev2 = float,class:^(pavucontrol)$
    windowrulev2 = float,class:^(blueman-manager)$
    windowrulev2 = float,class:^(nm-connection-editor)$
    windowrulev2 = float,class:^(file-roller)$
    windowrulev2 = float,class:^(org.gnome.Calculator)$
    windowrulev2 = float,class:^(org.gnome.Nautilus)$,title:^(Properties)$
    
    # Float all dialogs
    windowrulev2 = float,class:^(.*)$,title:^(Open File)$
    windowrulev2 = float,class:^(.*)$,title:^(Save File)$
    windowrulev2 = float,class:^(.*)$,title:^(Open Folder)$
    windowrulev2 = float,class:^(.*)$,title:^(Choose Files)$
    
    # Size specific floating windows
    windowrulev2 = size 800 600,class:^(pavucontrol)$
    windowrulev2 = size 400 300,class:^(org.gnome.Calculator)$
    
    # Center floating windows
    windowrulev2 = center,floating:1
    
    # Workspace assignments
    windowrulev2 = workspace 1,class:^(firefox)$
    windowrulev2 = workspace 1,class:^(google-chrome)$
    windowrulev2 = workspace 2,class:^(code)$
    windowrulev2 = workspace 2,class:^(nvim)$
    windowrulev2 = workspace 3,class:^(discord)$
    windowrulev2 = workspace 3,class:^(slack)$
    
    # Opacity rules
    windowrulev2 = opacity 0.9,class:^(kitty)$
    windowrulev2 = opacity 0.95,class:^(code)$
    
    # No shadow for specific windows
    windowrulev2 = noshadow,floating:0
    
    # Keep certain windows on top
    windowrulev2 = pin,class:^(pavucontrol)$
    windowrulev2 = pin,class:^(org.gnome.Calculator)$
    
    # Inhibit idle for media applications
    windowrulev2 = idleinhibit focus,class:^(mpv)$
    windowrulev2 = idleinhibit focus,class:^(firefox)$,title:^(.* - YouTube.*)$
    windowrulev2 = idleinhibit focus,class:^(google-chrome)$,title:^(.* - YouTube.*)$
    
    # Hide title bars for specific apps when tiled
    windowrulev2 = noborder,class:^(firefox)$,floating:0
    windowrulev2 = noborder,class:^(google-chrome)$,floating:0
  '';
}
