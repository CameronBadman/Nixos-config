{ config, lib, pkgs, ... }: {
  networking = {
    hostName = "nixos";
    wireless = {
      enable = true;
      networks."" = {
        psk = "";
      };
    };
  };
}

