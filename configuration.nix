{ config, lib, pkgs, ... }:
{
  imports = [
    <home-manager/nixos>
    ./hardware-configuration.nix
    ./modules 
  ];
  
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "24.11";
}

