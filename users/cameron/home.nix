{ config, pkgs, inputs, ... }:

{
  # Home Manager needs to know about your user
  home.username = "cameron";
  home.homeDirectory = "/home/cameron";
  home.stateVersion = "23.11";

  # XDG configuration
  fonts.fontconfig.enable = false;
  xdg.enable = true;
  xdg.cacheHome = "/home/cameron/.cache";
  
  # Create .cache/gopls directory
  home.file.".cache/gopls/.keep".text = "";

  # Basic home configuration
  home.packages = with pkgs; [
    # Add user-specific packages here
    htop
    neofetch
    tree
    
    # Add your neovim flake package
    inputs.nvim-flake.packages.${pkgs.system}.default
  ];

  # Git configuration
  programs.git = {
    enable = true;
    package = pkgs.git;
    userName = "CameronBadman";
    userEmail = "cbadwork@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
      core.editor = "nvim";
    };
  };

  # SSH configuration
  programs.ssh = {
    enable = true;
    matchBlocks = {
      "github.com" = {
        identityFile = "~/.ssh/github_key";
        extraOptions = { AddKeysToAgent = "yes"; };
      };
      "moss" = {
        hostname = "moss.labs.eait.uq.edu.au";
        user = "s4722396";
        identityFile = "~/.ssh/id_ed25519";
        setEnv = {
          TERM = "xterm-256color";
        };
        forwardAgent = true;
        forwardX11 = true;
      };
    };
  };

  # Bash configuration
  programs.bash = {
    enable = true;
    shellAliases = {
      ll = "ls -la";
      la = "ls -la";
      l = "ls -l";
      ".." = "cd ..";
      "..." = "cd ../..";
    };
  };

  # Enable some basic programs
  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
  };

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;
}
