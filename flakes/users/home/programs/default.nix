# home/programs/default.nix - Program configurations
{ config, lib, pkgs, ... }: {
  imports = [
    ./git.nix
    ./kitty.nix
    ./tmux.nix
    ./chrome.nix
    ./shell.nix
  ];
}
