{ config, lib, pkgs, ... }:
{
  imports = [ ];
  
  sops = {
    defaultSopsFile = ./secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "/home/cameron/.config/sops/age/keys.txt";
  };
}

