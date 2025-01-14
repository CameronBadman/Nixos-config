{ config, lib, pkgs, ... }:
{
  networking = {
    wireless = {
      enable = true;
      networks = {
        "Network" = {
          psk = "psk";
        };
      };
    };
    hostName = "nixos";
  };
}
