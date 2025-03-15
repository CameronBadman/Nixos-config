{ config, pkgs, ... }:

{
  # Install asus-specific tools for fan control
  environment.systemPackages = with pkgs; [
    linuxPackages.asus-nb-ctrl  # ASUS Notebook Control 
    lm_sensors                  # For monitoring temperatures
  ];
  
  # Enable the asus-linux service if available
  hardware.asus.enable = true;
  
  # Some ASUS laptops work well with TLP for advanced power management
  services.tlp = {
    enable = true;
    settings = {
      # Performance mode when plugged in
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      
      # More aggressive fan profile on AC
      PLATFORM_PROFILE_ON_AC = "performance";
      PLATFORM_PROFILE_ON_BAT = "balanced";
    };
  };
  
  # Enable thermald for better thermal management
  services.thermald.enable = true;
}
