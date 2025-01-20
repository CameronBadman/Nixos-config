{ config, pkgs, lib, ... }: {
  imports = [ ./ghosty.nix ./tmux.nix ];

  environment.systemPackages = with pkgs; [ yazi wl-clipboard ];
}
