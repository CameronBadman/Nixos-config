{
  description = "User configuration for Cameron";
  
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };
  
  outputs = { self, nixpkgs }: {
    homeManagerModules.default = { config, lib, pkgs, ... }: {
      imports = [
        ./home/default.nix
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
