{
  description = "Hardware configuration - Bluetooth, audio, networking, etc.";
  
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };
  
  outputs = { self, nixpkgs }: {
    nixosModules.default = { config, lib, pkgs, ... }: {
      imports = [ ./core/default.nix ];
      
      boot.kernelModules = [ "kvm-amd" "btusb" "btintel" "hid-generic" "uhid" ];
      
      hardware.bluetooth = {
        enable = true;
        powerOnBoot = true;
        settings = {
          General = {
            Experimental = true;
          };
        };
      };
      
      hardware.enableRedistributableFirmware = true;
      
      services.blueman.enable = true;
      
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        jack.enable = true;
      };
      
      environment.systemPackages = with pkgs; [
        bluez
        bluez-tools
        pavucontrol
      ];
      
      hardware.enableAllFirmware = true;
      
      services.udisks2.enable = true;
      services.udev.packages = [ pkgs.android-udev-rules ];
      
      services.upower.enable = true;
      
      systemd.tmpfiles.rules = [
        "w /sys/devices/system/cpu/cpufreq/boost - - - - 0"
      ];
    };
  };
}
