{ config, lib, pkgs, ... }: {
  imports = [
    ./dunst.nix
    ./waybar.nix
    ./windowrules.nix
    ./hypr-keybinds.nix
    ./workspaces.nix
  ];
}
