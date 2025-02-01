{ config, pkgs, ... }: {
  # Essential kernel modules - both are needed for Intel Bluetooth
  boot.kernelModules = [ "btintel" "btusb" ];

  # Firmware packages
  hardware.firmware = [ pkgs.linux-firmware ];

  # Bluetooth configuration
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Experimental = false; # Disabled unless specifically needed
        Enable = "Source,Sink,Media,Socket"; # Common audio profiles
      };
    };
  };

  # Prevent USB autosuspend which can cause connectivity issues
  boot.extraModprobeConfig = ''
    options btusb enable_autosuspend=0
    options bluetooth disable_ertm=1  # Enhanced Retransmission Mode can cause issues
  '';

  # Optional but recommended services
  services.blueman.enable = true; # Bluetooth manager
}
