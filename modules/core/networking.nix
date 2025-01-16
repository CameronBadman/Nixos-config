{ config, lib, pkgs, ... }:

let
  secrets = import ../secrets/default.nix;
in {
  networking.wireless = {
    enable = true;
    networks = {
      "${secrets.wifi.ssid}" = {
        psk = secrets.wifi.psk;
      };
    };
  };
}

