{ config, lib, pkgs, inputs, ... }: {
  # Previous configuration remains the same...

  # Add system-wide packages
  environment.systemPackages = with pkgs; [
    git
  ];

  # User configuration
  users.users.cameron = {
    isNormalUser = true;
    extraGroups = [ "wheel" "users" "docker" ];
    initialPassword = "temppass";
    shell = pkgs.bash;
    home = "/home/cameron";
    createHome = true;
  };

  # Home Manager configuration
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    users.cameron = { pkgs, ... }: {
      home.stateVersion = "23.11";
      fonts.fontconfig.enable = false;
      xdg.enable = false;

      # Git configuration
      programs.git = {
        enable = true;
        package = pkgs.git;
        userName = "CameronBadman";  # Replace with your git username
        userEmail = "cbadwork@gmail.com";  # Replace with your git email
        extraConfig = {
          init.defaultBranch = "main";
          core.editor = "nvim";
        };
      };

      # SSH configuration remains the same
      programs.ssh = {
        enable = true;
        matchBlocks = {
          "github.com" = {
            identityFile = "~/.ssh/github_key";
            extraOptions = { AddKeysToAgent = "yes"; };
          };
        };
      };

      # Make nvim-flake available
      home.packages = [ inputs.nvim-flake.packages.${pkgs.system}.default ];
    };
  };

  # Sudo configuration remains the same
  security.sudo.extraConfig = ''
    Defaults env_keep += "HOME"
    Defaults env_keep += "XDG_DATA_DIRS"
    Defaults env_keep += "NIXOS_OZONE_WL"
    Defaults env_keep += "XDG_CONFIG_HOME"
    Defaults env_keep += "XDG_CACHE_HOME"
    Defaults env_keep += "XDG_DATA_HOME"
    Defaults env_keep += "NEOVIM_STATE_DIR"
  '';
}
