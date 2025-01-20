{ config, pkgs, lib, ... }: {
  imports = [ ./ghosty.nix ./tmux.nix ./alacritty.nix ];

  environment.systemPackages = with pkgs; [ yazi wl-clipboard ];
}
