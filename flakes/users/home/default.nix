# home/default.nix
{ config, lib, pkgs, inputs, ... }: {
  imports = [
    ./programs
  ];
  
  home = {
    sessionVariables = {
      TERMINAL = "kitty";
      EDITOR = "nvim";
      BROWSER = "chrome";
      MOZ_ENABLE_WAYLAND = "1";
      QT_QPA_PLATFORM = "wayland";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      SDL_VIDEODRIVER = "wayland";
    };
  };
  
  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
      desktop = "$HOME/Desktop";
      documents = "$HOME/Documents";
      download = "$HOME/Downloads";
      music = "$HOME/Music";
      pictures = "$HOME/Pictures";
      videos = "$HOME/Videos";
      templates = "$HOME/Templates";
      publicShare = "$HOME/Public";
    };
  };
  
  gtk = {
  enable = true;
  theme = {
    name = "Adwaita-dark";
    package = pkgs.gnome-themes-extra;
  };
  iconTheme = {
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
  };
  };
  
  qt = {
    enable = true;
    platformTheme.name = "adwaita";
    style.name = "adwaita-dark";
  };
  
  fonts.fontconfig.enable = true;
  programs.home-manager.enable = true;
}
