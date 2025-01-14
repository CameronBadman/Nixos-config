{ config, lib, pkgs, ... }:
{
  imports = [
    ./nvidia.nix
    ./bluetooth.nix
    ./audio.nix
  ];
}
