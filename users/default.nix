{ config, lib, pkgs, ... }: {
  imports = [
    ./cameron
  ];

  environment.systemPackages = with pkgs; [
    git
  ];

  security.sudo.extraConfig = ''
    Defaults env_keep += "HOME"
    Defaults env_keep += "XDG_DATA_DIRS"
    Defaults env_keep += "NIXOS_OZONE_WL"
    Defaults env_keep += "XDG_CONFIG_HOME"
    Defaults env_keep += "XDG_CACHE_HOME"
    Defaults env_keep += "XDG_DATA_HOME"
    Defaults env_keep += "NEOVIM_STATE_DIR"
  '';

  time.timeZone = "Australia/Brisbane";
  virtualisation.docker.enable = true;
}
