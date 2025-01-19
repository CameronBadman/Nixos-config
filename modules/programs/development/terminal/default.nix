{ config, pkgs, lib, ... }: {
  imports = [ ./alacritty.nix ./tmux.nix ];

  environment.systemPackages = with pkgs; [ yazi wl-clipboard ];
}
