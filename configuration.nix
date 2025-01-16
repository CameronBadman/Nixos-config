{ config, lib, pkgs, inputs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./modules
  ];
  
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "24.11";
}

