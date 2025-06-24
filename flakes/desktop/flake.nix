# flakes/desktop/default.nix - Main desktop flake
{
  description = "Modular Hyprland configuration flake";
  
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };
  
  outputs = { self, nixpkgs }: {
    nixosModules.default = { config, lib, pkgs, ... }: {
      # Import all the modular components
      imports = [
        ./modules/hyprland-base.nix
        ./modules/graphical-settings.nix
        ./modules/keybinds.nix
        ./modules/workspaces.nix
        ./modules/window-rules.nix
        ./modules/waybar.nix
        ./modules/dunst.nix
        ./modules/swww.nix
      ];
    };
  };
}
