{ config, pkgs, ... }:
{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  
  time.timeZone = "Australia/Brisbane";
  i18n.defaultLocale = "en_AU.UTF-8";
  
  console.keyMap = "us";
  
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    substituters = [
      "https://cache.nixos.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];
  };
  
  nixpkgs.config.allowUnfree = true;
  
  environment.systemPackages = with pkgs; [
    firefox
    google-chrome
    nautilus
    kitty
    grim
    slurp
    dunst
    libnotify
    rofi
    waybar
    hyprpaper
    networkmanagerapplet
    brightnessctl
    neofetch
    htop
    usbutils
    pciutils
    lshw
  ];
  
  system.stateVersion = "24.05";
}
