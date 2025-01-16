{ config, pkgs, ... }:

{
  imports = [
    ./terminal
    ./nvim/neovim.nix
    ./containers
    ./languages
  ];
}


