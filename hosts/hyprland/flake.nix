{
  description = "Hyprland configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland/v0.46.2"; # Pinned to working version
    };
  };

  outputs = { self, nixpkgs, home-manager, hyprland, ... }@inputs: {
    nixosConfigurations.hyprland = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./default.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.cameron = import ./home.nix;
        }
      ];
      specialArgs = { inherit inputs; };
    };
  };
}
