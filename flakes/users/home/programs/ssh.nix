{ config, pkgs, ... }:

{
  programs.ssh = {
    enable = true;

    # SSH client configuration
    matchBlocks = {
      # UQ Friday research server
      "friday" = {
        hostname = "friday.research.dc.uq.edu.au";
        user = "s4722396";
        identityFile = "~/.ssh/id_ed25519"; # Using your ed25519 key
        port = 22;
        # Add these for better connectivity
        serverAliveInterval = 60;
        serverAliveCountMax = 3;
        # Disable strict host key checking for first connection (optional)
        extraOptions = {
          StrictHostKeyChecking = "accept-new";
        };
      };
      "rangpur" = {
        hostname = "rangpur.compute.eait.uq.edu.au.";
        user = "s4722396";
        identityFile = "~/.ssh/id_ed25519"; # Using your ed25519 key
        port = 22;
        # Add these for better connectivity
        serverAliveInterval = 60;
        serverAliveCountMax = 3;
        # Disable strict host key checking for first connection (optional)
        extraOptions = {
          StrictHostKeyChecking = "accept-new";
        };
      };

      # You can add more UQ servers here
      "uq-*" = {
        user = "s4723961";
        identityFile = "~/.ssh/id_ed25519"; # Using your ed25519 key
      };
    };

    # Global SSH settings
    extraConfig = ''
      # Keep connections alive
      TCPKeepAlive yes
      ServerAliveInterval 60
      ServerAliveCountMax 3

      # Speed up connections
      ControlMaster auto
      ControlPath ~/.ssh/control-%r@%h:%p
      ControlPersist 5m
    '';
  };

  # Ensure SSH directory and permissions
  home.file.".ssh/config".text = ""; # This ensures ~/.ssh exists
}
