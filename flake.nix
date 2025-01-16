{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    
    # Add agenix
    agenix.url = "github:ryantm/agenix";
  };

  outputs = { self, nixpkgs, home-manager, agenix, ... }@inputs: {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
          agenix.nixosModules.default  # Add this line
        ];
        specialArgs = { inherit inputs self; };
      };
    };
  };
}

