{
  description = "Your NixOS configuration";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Private config is now inside the repo
    private.url = "path:./private";
  };

  outputs = { self, nixpkgs, home-manager, private, ... }@inputs: {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
          private.nixosModules.networking
        ];
        specialArgs = { inherit inputs self; };
      };
    };
  };
}

