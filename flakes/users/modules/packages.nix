# modules/packages.nix - General tools and utilities
{ config, lib, pkgs, ... }: {
  # System-wide packages - general tools only
  environment.systemPackages = with pkgs; [
    # System monitoring and info
    btop
    htop
    neofetch
    lm_sensors
    awscli2
    
    # File utilities
    tree
    fd
    ripgrep
    fzf
    
    # Archive tools
    unzip
    zip
    p7zip
    
    # Network tools
    wget
    curl
    
    # Hardware utilities
    usbutils
    pciutils
    lshw
    lsof
    
    # Document and office tools
    texliveFull        # LaTeX
    pandoc            # Document converter
    libreoffice       # Office suite
    
    # Media tools
    vlc
    spotify
    
    # Image tools
    feh               # Image viewer
    imagemagick       # Image manipulation
    ffmpeg
    
    # System utilities
    brightnessctl     # Brightness control
    pamixer          # Audio control
    playerctl        # Media control
    
    # Wayland utilities
    wl-clipboard     # Clipboard
    grim             # Screenshots
    slurp            # Screen selection
    
    # File managers
    nautilus         # GUI file manager
    
    # Network manager
    networkmanagerapplet
    
    # Notifications
    libnotify
    
    # Fonts (system-wide)
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
  ];
  
  # Nerd fonts - updated syntax
  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.droid-sans-mono  
    nerd-fonts.jetbrains-mono
  ];
  
  # Font configuration
  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      serif = [ "Noto Serif" ];
      sansSerif = [ "Noto Sans" ];
      monospace = [ "FiraCode Nerd Font" ];
      emoji = [ "Noto Color Emoji" ];
    };
  };
}
