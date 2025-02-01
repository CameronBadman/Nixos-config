{ config, lib, pkgs, ... }: {
  # Set the timezone to Brisbane, Australia
  time.timeZone = "Australia/Brisbane";
  # Enable Docker
  virtualisation.docker.enable = true;
  # Add your user to the "docker" group
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

      # SSH configuration
      programs.ssh = {
        enable = true;
        matchBlocks = {
          "github.com" = {
            identityFile = "~/.ssh/github_key";
            extraOptions = { AddKeysToAgent = "yes"; };
          };
        };
      };
    };
  };
  # Sudo configuration
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
