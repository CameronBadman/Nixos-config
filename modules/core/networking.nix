{ config, lib, pkgs, ... }:
{
  sops.secrets = {
    "wifi/ssid" = {
      sopsFile = ../../secrets/wifi.enc.yaml;
    };
    "wifi/password" = {
      sopsFile = ../../secrets/wifi.enc.yaml;
    };
  };

  networking = {
    wireless = {
      enable = true;
      networks = {
        "${config.sops.secrets."wifi/ssid".path}" = {
          pskFile = config.sops.secrets."wifi/password".path;
        };
      };
    };
    hostName = "nixos";
  };
}

