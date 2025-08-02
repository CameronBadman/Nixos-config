{
  description = "Hardware configuration - Bluetooth, audio, networking, etc.";
  
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };
  
  outputs = { self, nixpkgs }: {
    nixosModules.default = { config, lib, pkgs, ... }: {
      # Import the core module (networking stuff)
      imports = [ ./core/default.nix ];
      
      # Kernel modules for hybrid graphics (AMD + NVIDIA)
      boot.kernelModules = [ "kvm-amd" "amdgpu" ];
      boot.initrd.kernelModules = [ "amdgpu" ];
      
      # Video drivers for hybrid setup
      services.xserver.videoDrivers = [ "nvidia" "amdgpu" ];
      
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

      hardware.enableAllFirmware = true;
      
      # Enhanced graphics configuration for hybrid setup
      hardware.graphics = {
        enable = true;
        enable32Bit = true;
        extraPackages = with pkgs; [
          amdvlk  # AMD Vulkan driver
        ];
        extraPackages32 = with pkgs.pkgsi686Linux; [
          amdvlk  # 32-bit AMD Vulkan
        ];
      };
      
      # USB and device detection
      services.udisks2.enable = true;
      services.udev.packages = [ pkgs.android-udev-rules ];
      
      # Power management
      services.upower.enable = true;
    };
  };
}
