{ config, lib, pkgs, ... }: {
  wayland.windowManager.hyprland.settings = {
    windowrulev2 = [
      "float,class:^(pavucontrol)$"
      "float,class:^(file_progress)$"
      "float,class:^(confirm)$"
      "float,class:^(dialog)$"
      "float,class:^(download)$"
      "float,class:^(notification)$"
      "float,class:^(error)$"
      "float,class:^(splash)$"
      "float,title:^(Open File)$"
      "float,title:^(branchdialog)$"
      "float,title:^(Volume Control)$"
    ];
  };
}
