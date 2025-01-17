{ config, pkgs, inputs, ... }:
{
  imports = [
    ./terminal
    (import ./nvim/neovim.nix { inherit config pkgs inputs; })
    ./containers
    ./languages
  ];
}
