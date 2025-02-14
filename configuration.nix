{ config, lib, pkgs, inputs, ... }: {
  imports = [ ./hardware-configuration.nix ./modules ./hosts ./users ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs.config = lib.mkDefault { allowUnfree = true; };

  system.stateVersion = "24.11";
}

