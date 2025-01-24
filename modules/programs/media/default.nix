{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    google-chrome
    vesktop
    playerctl
    pavucontrol
    blueman
    bluetuith
    (import ./cider.nix { inherit pkgs lib; })
  ];
}
