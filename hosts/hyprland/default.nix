{ config, lib, pkgs, ... }: {
  imports = [ ./config ];  # Import your Hyprland-specific configs
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
  # Enable Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
  # Enable home-manager
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.cameron = import ./home.nix;
  # Make sure we have these packages available system-wide
  environment.systemPackages = with pkgs; [
    waybar
    dunst
    wofi
    alacritty
    dolphin
    # Add these packages for screen sharing
    xdg-desktop-portal
    xdg-desktop-portal-wlr
    xdg-desktop-portal-gtk
    xdg-utils
    slurp
    wl-clipboard
  ];
  
  # Enhanced XDG portal configuration for screen sharing
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
  
  # Make sure D-Bus is enabled
  services.dbus.enable = true;
  
  # Ensure PipeWire is properly configured for screen sharing
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
  
  # Link XDG portal paths
  environment.pathsToLink = [ "/share/xdg-desktop-portal" ];
}
