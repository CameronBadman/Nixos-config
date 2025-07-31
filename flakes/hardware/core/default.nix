{ config, lib, pkgs, ... }:
{
  imports = [ 
    ./networking.nix
    ./fans.nix
    ./display.nix
  ];
}

