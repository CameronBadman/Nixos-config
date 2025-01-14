{ config, lib, pkgs, ... }:
{
  imports = [
    <home-manager/nixos>
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";  # Add this line
    users.cameron = { pkgs, ... }: {
      home.stateVersion = "23.11";
      fonts.fontconfig.enable = false;
      xdg.enable = false;
    };
  };

  users.users.cameron = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    initialPassword = "temppass";
    shell = pkgs.bash;
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

