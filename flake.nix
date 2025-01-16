{
  description = "Your NixOS configuration";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, nixpkgs, agenix, home-manager, ... }@inputs: {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          agenix.nixosModules.default
          home-manager.nixosModules.home-manager
          ({ config, lib, ... }: {
            age.secrets.test = {
              file = ./secrets/test.age;
              owner = "cameron";
              mode = "400";
            };
          })
        ];
        specialArgs = { inherit inputs self; };
      };
    };
  };
}

