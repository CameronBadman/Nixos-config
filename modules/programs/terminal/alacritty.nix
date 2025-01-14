{ config, lib, pkgs, ... }:
{
  home-manager.users.cameron = { pkgs, ... }: {
    programs.alacritty = {
      enable = true;
      settings = {
        shell = {
          program = "${pkgs.bash}/bin/bash";
          args = [
            "--login"  # login shell
          ];
        };
        window = {
          opacity = 0.9;  
        };
      };
    };
    xdg.configFile."alacritty" = {
      source = pkgs.fetchFromGitHub {
        owner = "CameronBadman";
        repo = "Alacritty";
        rev = "main";
        sha256 = "sha256-5pv7ktxF4V1wQSFRuk8IhecFnRuz33lOeIiIUwVWK9Q=";
      };
      recursive = true;
    };
  };
}

