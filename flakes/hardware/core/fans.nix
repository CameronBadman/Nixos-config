# flakes/hardware/modules/fans.nix
{ config, lib, pkgs, ... }: {
  # ASUS laptop fan and thermal management
  
  # Load ASUS-specific kernel modules
  boot.kernelModules = [ 
    "asus-nb-wmi" 
    "asus-wmi"
    "coretemp"
    "k10temp"
  ];
  
  # Fan control packages
  environment.systemPackages = with pkgs; [
    lm_sensors
    asusctl
    mission-center  # GUI system monitor (replacement for psensor)
    wlr-randr
  ];
  
  # Enable hardware sensors
  hardware.enableRedistributableFirmware = true;
  
  # Set CPU governor to performance (will make fans work harder)
  powerManagement.cpuFreqGovernor = "performance";
  
  # Enable ASUS control service
  services.asusd = {
    enable = true;
    enableUserService = true;
  };
  
  # Systemd service to set aggressive thermal policy
  systemd.services.asus-thermal-aggressive = {
    description = "Set ASUS thermal policy to performance";
    wantedBy = [ "multi-user.target" ];
    after = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      # Set thermal policy to performance (makes fans more aggressive)
      if [ -w /sys/devices/platform/asus-nb-wmi/throttle_thermal_policy ]; then
        echo 2 > /sys/devices/platform/asus-nb-wmi/throttle_thermal_policy
      fi
      
      # Try alternative paths
      if [ -w /sys/devices/platform/asus-wmi/throttle_thermal_policy ]; then
        echo 2 > /sys/devices/platform/asus-wmi/throttle_thermal_policy
      fi
    '';
  };
  
  # Temperature monitoring and logging
  systemd.services.temp-monitor = {
    description = "Log system temperatures";
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.lm_sensors}/bin/sensors";
      Restart = "always";
      RestartSec = 60;
    };
  };
}
