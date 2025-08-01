# home/default.nix - Home Manager configuration entry point
{ config, lib, pkgs, inputs, ... }: {
  imports = [
    ./programs
  ];
  
  home = {
    username = "cameron";
    homeDirectory = "/home/cameron";
    stateVersion = "23.11";
    
    # User-specific packages
    packages = with pkgs; [
      # Browsers
      google-chrome  # Your preferred browser
      texstudio
      
      # Media
      discord
      legcord
      
      # Office/productivity 
      obsidian
      
      # Graphics
      gimp
      
      # Password manager
      bitwarden
      
      # Development (non-language specific)
      docker-compose
      
      # Communication
      slack
      zoom-us
    ];
    
    # Session variables
    sessionVariables = {
      TERMINAL = "kitty";
      EDITOR = "nvim";
      BROWSER = "zen";  
      MOZ_ENABLE_WAYLAND = "1";  
      QT_QPA_PLATFORM = "wayland";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      SDL_VIDEODRIVER = "wayland";
    };
  };
  
  # Background app services for faster startup
  systemd.user.services = {
    legcord-background = {
      Unit = {
        Description = "Start Legcord in background";
        After = [ "graphical-session.target" ];
        Wants = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = "${pkgs.legcord}/bin/legcord --start-minimized";
        Restart = "no";
        Type = "forking";
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
    };
  };
  
  # XDG configuration
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
  
  # GTK theming
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
  
  # Qt theming
  qt = {
    enable = true;
    platformTheme.name = "adwaita";
    style.name = "adwaita-dark";
  };
  
  # Font configuration
  fonts.fontconfig.enable = true;
  
  programs.home-manager.enable = true;
}
