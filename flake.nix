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
    # Add NixVim input
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    { self, nixpkgs, home-manager, sops-nix, kubectl-nvim, nixvim, ... }@inputs:
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
              # Add NixVim module to home-manager
              home-manager.users.cameron.imports =
                [ nixvim.homeManagerModules.nixvim ];
            }
            ./users
            sops-nix.nixosModules.sops
          ];
        };
      };
      packages.x86_64-linux.default =
        self.nixosConfigurations.nixos.config.system.build.toplevel;
    };
}
