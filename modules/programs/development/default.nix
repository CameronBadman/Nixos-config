{ config, pkgs, ... }:

{
  imports = [
    ./terminal
    ./nvim
    ./containers
    ./languages
  ];
}


