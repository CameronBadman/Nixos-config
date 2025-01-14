
{ config, pkgs, lib, ... }:

let
  utils = import ../utils.nix { inherit lib; };
in
{
  imports = utils.getImports ./.;

  environment.systemPackages = with pkgs; [
    alacritty
    tmux
    yazi
    wl-clipboard
  ];
}

