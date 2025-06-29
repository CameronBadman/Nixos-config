{ config, lib, pkgs, ... }:
{
  imports = [ 
    ./networking.nix
    ./sops.nix
    ./fans.nix
    ./display.nix
  ];
}

