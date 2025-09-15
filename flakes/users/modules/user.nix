# modules/user.nix - User account configuration
{ config, lib, pkgs, ... }: {
  # User configuration

 users.users.cameron = {
    isNormalUser = true;
    extraGroups = [ 
      "wheel"           # sudo access
      "users"           # general users group
      "docker"          # docker access
      "networkmanager"  # network management
      "video"           # video devices
      "audio"           # audio devices
      "input"           # input devices
      "bluetooth"
      "render"          # GPU rendering
      "libvirtd"        # virtualization
    ];
    initialPassword = "temppass";
    shell = pkgs.bash;
    description = "Cameron Badman";
  };
  
  # Security configuration
  security.sudo.wheelNeedsPassword = true;
  
  # Environment variables
  environment.variables = {
    TERMINAL = "kitty";
    EDITOR = "nvim";
    BROWSER = "chrome";
  };
}
