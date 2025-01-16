{ config, lib, pkgs, inputs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./modules
    ./hosts
    ./users
  ];

  environment.systemPackages = with pkgs; [
    inputs.agenix.packages.x86_64-linux.default
  ];
  
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  nixpkgs.config = lib.mkDefault {
    allowUnfree = true;
  };

  system.stateVersion = "24.11";
}

