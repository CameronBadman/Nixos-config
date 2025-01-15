{ config, lib, pkgs, ... }:
{
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
            extraOptions = {
              AddKeysToAgent = "yes";
            };
          };
        };
      };
    };
  };
  
  users.users.cameron = {
    isNormalUser = true;
    extraGroups = [ "wheel" "users" ];
    initialPassword = "temppass";
    shell = pkgs.bash;
    home = "/home/cameron";
    createHome = true;  
  };
  
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
