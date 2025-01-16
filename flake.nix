{
  description = "Your NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, agenix, ... }@inputs: {
    nixosConfigurations = {
      your-hostname = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";  # adjust if you're using a different architecture
        modules = [
          ./configuration.nix
          agenix.nixosModules.default
        ];
        specialArgs = { inherit inputs; };
      };
    };
  };
}
