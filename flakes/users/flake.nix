{
  description = "User configuration for Cameron";
  
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  
  outputs = { self, nixpkgs, home-manager }: {
    nixosModules.default = { config, lib, pkgs, inputs, ... }: {
      # Import all user modules
      imports = [
        ./modules/user.nix
        ./modules/packages.nix
      ];
      
      # Home Manager configuration
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = { inherit inputs; };
        
        users.cameron = import ./home;
      };
    };
    
    # Expose individual modules for selective importing
    nixosModules = {
      user = import ./modules/user.nix;
      packages = import ./modules/packages.nix;
    };
  };
}
