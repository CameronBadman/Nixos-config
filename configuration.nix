{ config, lib, pkgs, ... }:

{
  imports = [ 
    ./hardware-configuration.nix
    ./modules/core
    ./modules/desktop
    ./modules/hardware
    ./modules/programs
    ./modules/users
  ];

  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "24.11";
}
