# private/networking.nix
{ config, pkgs, ... }: {
  networking = {
    wireless = {
      enable = true;
      networks = {
        "" = {
          psk = "";
        };
      };
    };
  };
