{ config, lib, pkgs, inputs ? {}, ... }: {
  imports = [ ./config ];  # Import your Hyprland-specific configs
  
  # Your environment variables
  environment = {
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
      WLR_NO_HARDWARE_CURSORS = "1";
      LIBVA_DRIVER_NAME = "nvidia";
      GBM_BACKEND = "nvidia-drm";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      WLR_RENDERER = "vulkan";
      XDG_RUNTIME_DIR = "/run/user/1000";
      WAYLAND_DISPLAY = "wayland-1";
    };
  };
  
  # Enable the X11 windowing system
  services.xserver = {
    enable = true;
    displayManager.gdm = {
      enable = true;
      wayland = true;
    };
  };
  
  # Enable Hyprland with package from flake input if available
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    # Use package from flake input if available
    package = lib.mkIf (inputs ? hyprland) inputs.hyprland.packages.${pkgs.system}.hyprland;
    extraPackages = with pkgs; [ 
      mesa 
      libdrm
      libinput
      libseat
      wayland
      wayland-protocols
      pixman
      udev
      libxkbcommon
    ];
  };
  
  # Home-manager configuration
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.cameron = import ./home.nix;
  
  # Add mesa and related packages to system packages
  environment.systemPackages = with pkgs; [
    waybar
    dunst
    wofi
    alacritty
    dolphin
    
    # Graphics and display dependencies
    mesa
    mesa.dev  # Development headers containing gbm.pc
    libdrm
    
    # Screen sharing packages
    xdg-desktop-portal
    xdg-desktop-portal-wlr
    xdg-desktop-portal-gtk
    xdg-utils
    slurp
    wl-clipboard
  ];
  
  # Make GBM and related libraries available to the build process
  nixpkgs.overlays = [
    (final: prev: {
      # Fix Aquamarine to find GBM
      aquamarine = (prev.aquamarine.override {}).overrideAttrs (oldAttrs: {
        # Add explicit build inputs
        buildInputs = (oldAttrs.buildInputs or []) ++ [
          prev.mesa
          prev.mesa.dev
          prev.libdrm
        ];
        
        # Set PKG_CONFIG_PATH to help find GBM
        preConfigure = (oldAttrs.preConfigure or "") + ''
          export PKG_CONFIG_PATH="${prev.mesa.dev}/lib/pkgconfig:${prev.libdrm}/lib/pkgconfig:$PKG_CONFIG_PATH"
        '';
      });
    })
  ];
  
  # Rest of your configuration...
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
    ];
    config = {
      common = {
        default = "*";
      };
      preferred = {
        "org.freedesktop.impl.portal.ScreenCast" = "wlr";
        "org.freedesktop.impl.portal.Screenshot" = "wlr";
      };
    };
  };
  
  services.dbus.enable = true;
  
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
  
  environment.pathsToLink = [ "/share/xdg-desktop-portal" ];
}
