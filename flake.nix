{
  description = "nixos config";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    kubectl-nvim = {
      url = "github:Ramilito/kubectl.nvim";
      flake = false;
    };
  };
  outputs = { self, nixpkgs, home-manager, sops-nix, kubectl-nvim, ...
    }@inputs: # Add kubectl-nvim here
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs self; };
          modules = [
            ./configuration.nix
            ./hosts
            ./modules
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit inputs; };
            }
            ./users
            sops-nix.nixosModules.sops
          ];
        };
      };
    };
}
