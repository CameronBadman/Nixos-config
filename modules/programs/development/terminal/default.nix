{ config, pkgs, lib, ... }: {
  imports = [ 
    ./ghosty.nix 
    ./alacritty.nix 
    ./kitty.nix
    ./bash.nix
    ./tmux.nix
  ];
  
  environment.systemPackages = with pkgs; [ 
    yazi 
    wl-clipboard 
    wezterm
    tmux
  ];
}
