{ config, lib, pkgs, ... }: {
  boot.kernelModules = [ 
    "typec" 
    "typec_displayport"
    "cros_ec_typec"
  ];
  
  services.xserver.videoDrivers = [ "nvidia" "amdgpu" ];
  
  hardware.nvidia = {
    open = false;  # Use closed source drivers for GTX 2060 Max-Q
    # ... your other nvidia settings
  };
  # Udev rules for USB-C
  services.udev.extraRules = ''
    # Force DisplayPort Alt Mode detection
    SUBSYSTEM=="typec", ACTION=="add", RUN+="${pkgs.kmod}/bin/modprobe typec_displayport"
  '';
}
