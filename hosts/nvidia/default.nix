{ config, lib, pkgs, ... }:
{
  hardware = {
    graphics.enable = true;
    nvidia = {
      modesetting.enable = true;
      powerManagement.enable = true;
      open = true;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      forceFullCompositionPipeline = true;
    };
  };

  services.xserver = {
    videoDrivers = ["nvidia"];
    xkb.options = "ctrl:swapcaps";
  };
}
