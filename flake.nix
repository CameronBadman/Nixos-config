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
    # You can remove kubectl-nvim from here since it'll be in your nixvim flake
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Add your nixvim config as an input
    my-nixvim = {
      url = "path:/path/to/your/nixvim/config";  # Or git URL if you push it
    };
  };
  outputs = { self
    , nixpkgs
    , home-manager
    , sops-nix
    , nixvim
    , my-nixvim
    , ... }@inputs:
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
              home-manager.users.cameron = {
                imports = [ 
                  # Import your nixvim config
                  my-nixvim.homeManagerModules.default
                ];
              };
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
