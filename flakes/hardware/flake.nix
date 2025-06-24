{
  description = "Hardware configuration - Bluetooth, audio, networking, etc.";
  
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };
  
  outputs = { self, nixpkgs }: {
    nixosModules.default = { config, lib, pkgs, ... }: {
      # Import the core module (networking stuff)
      imports = [ ./core/default.nix ];
      
      # Bluetooth configuration
      hardware.bluetooth = {
        enable = true;
        powerOnBoot = true;
      };
      
      services.blueman.enable = true;
      
      # Audio configuration
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        jack.enable = true;
      };
      
      # Hardware packages
      environment.systemPackages = with pkgs; [
        bluez
        bluez-tools
        pavucontrol
      ];
      
      # Hardware-specific optimizations
      hardware.graphics = {
        enable = true;
        enable32Bit = true;
      };
      
      # USB and device detection
      services.udisks2.enable = true;
      services.udev.packages = [ pkgs.android-udev-rules ];
      
      # Power management
      services.upower.enable = true;
    };
  };
}
