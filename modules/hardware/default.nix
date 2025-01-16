{ config, lib, pkgs, ... }:
{
  imports = [
    ./bluetooth.nix
    ./audio.nix
  ];
}
