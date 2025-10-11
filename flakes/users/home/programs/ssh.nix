{ config, pkgs, ... }:
{
  programs.ssh = {
    enable = true;
    
    matchBlocks = {
      "*" = {
        extraOptions = {
          TCPKeepAlive = "yes";
          ServerAliveInterval = "60";
          ServerAliveCountMax = "3";
          ControlMaster = "auto";
          ControlPath = "~/.ssh/control-%r@%h:%p";
          ControlPersist = "5m";
        };
      };
    };
  };
  
  home.file.".ssh/config".text = "";
}
