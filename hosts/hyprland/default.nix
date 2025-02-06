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
  ];

  # Add any additional system-level settings needed for Hyprland
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
}
