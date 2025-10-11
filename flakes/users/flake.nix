# flakes/users/flake.nix
{
  description = "User configuration for Cameron";
  
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };
  
  outputs = { self, nixpkgs }: {
    homeManagerModules.default = { config, lib, pkgs, ... }: {
      imports = [
        ./home/default.nix
        ./home/programs/chrome.nix
        ./home/programs/git.nix
        ./home/programs/kitty.nix
        ./home/programs/shell.nix
        ./home/programs/ssh.nix
        ./home/programs/tmux.nix
      ];
    };
    
    nixosModules.default = { config, lib, pkgs, ... }: {
      imports = [
        ./modules/user.nix
        ./modules/packages.nix
      ];
      
      systemd.tmpfiles.rules = [
        "d /uni 0755 cameron users - -"
        "d /projects 0755 cameron users - -"
      ];
    };
  };
}
