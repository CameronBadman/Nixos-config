{ config, lib, pkgs, ... }: {
  wayland.windowManager.hyprland.settings = {
    windowrulev2 = [
      "monitor:cursor,class:.*"
      
      "opacity 1 0.98,class:.*"
      
      "float,class:^(pavucontrol)$"
      "float,class:^(blueman-manager)$"
      "float,class:^(nm-connection-editor)$"
      "float,class:^(file-roller)$"
      "float,class:^(org.gnome.Calculator)$"
      "float,class:^(org.gnome.Nautilus)$,title:^(Properties)$"
      
      "float,class:^(.*)$,title:^(Open File)$"
      "float,class:^(.*)$,title:^(Save File)$"
      "float,class:^(.*)$,title:^(Open Folder)$"
      "float,class:^(.*)$,title:^(Choose Files)$"
      
      "size 800 600,class:^(pavucontrol)$"
      "size 400 300,class:^(org.gnome.Calculator)$"
      
      "center,floating:1"
      
      "workspace 10,class:^(legcord)$"
      "workspace 9,class:^(Spotify)$"
      
      "opacity 0.9,class:^(kitty)$"
      "opacity 0.95,class:^(code)$"
      
      "noshadow,floating:0"
      
      "pin,class:^(pavucontrol)$"
      "pin,class:^(org.gnome.Calculator)$"
      
      "idleinhibit focus,class:^(mpv)$"
      "idleinhibit focus,class:^(firefox)$,title:^(.* - YouTube.*)$"
      "idleinhibit focus,class:^(google-chrome)$,title:^(.* - YouTube.*)$"
      "idleinhibit focus,class:^(Spotify)$"
      
      "noborder,class:^(firefox)$,floating:0"
      "noborder,class:^(google-chrome)$,floating:0"
    ];
  };
}
