{ config, lib, pkgs, ... }: {
  environment.systemPackages = with pkgs; [ bluez ];

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  services.blueman.enable = true;
}
