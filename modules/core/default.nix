{ config, lib, pkgs, ... }:
{
  imports = [ 
    ./boot.nix
    ./networking.nix
    ./sops.nix
  ];
}

