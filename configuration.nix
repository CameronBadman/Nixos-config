{ config, pkgs, ... }:

{
  # Boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # Time zone and locale
  time.timeZone = "Australia/Brisbane";
  i18n.defaultLocale = "en_AU.UTF-8";

  # Console keymap
  console.keyMap = "us";

  # Enable flakes and allow unfree
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  # Essential system packages only
  environment.systemPackages = with pkgs; [
  # Browsers
  firefox
  google-chrome
  
  # File manager
  nautilus
  
  # Terminal
  kitty
  
  # Desktop utilities
  grim
  slurp
  dunst
  libnotify
  rofi-wayland
  waybar
  hyprpaper
  networkmanagerapplet
  brightnessctl
  neofetch
  htop
  usbutils
  pciutils
  lshw
];  # System version
  system.stateVersion = "24.05";
}
