{ config, pkgs, ... }:

{
  # Essential kernel module
  boot.kernelModules = [ "btintel" ];

  # Official firmware package
  hardware.firmware = [ pkgs.linux-firmware ];

  # Bluetooth configuration
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings.General.Experimental = true; # Enable modern features
  };

  # Critical for Intel stability
  boot.extraModprobeConfig = "options btusb enable_autosuspend=0";
}
