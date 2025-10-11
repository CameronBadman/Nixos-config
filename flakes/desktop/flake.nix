# flakes/desktop/flake.nix
{
  description = "Modular Hyprland configuration flake";
  
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };
  
  outputs = { self, nixpkgs }: {
    homeManagerModules.default = { config, lib, pkgs, ... }: {
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
    
    nixosModules.default = { config, lib, pkgs, ... }: {
      imports = [
        ./modules/system.nix
      ];
    };
  };
}
