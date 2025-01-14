{ config, pkgs, ... }:

{
  imports = [
    ./editors
    ./terminal
    ./tools
    ./containers
    ./languages
    ./media
  ];
}

