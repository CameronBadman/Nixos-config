{ config, lib, pkgs, ... }:
{
  imports = [ 
    ./networking.nix
    ./sops.nix
  ];
}

