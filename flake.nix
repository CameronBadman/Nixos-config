{
  description = "NixOS Configuration";
  
  inputs = {
   nixpkgs.url = "github:nixos/nixpkgs/e3e32b642a31e6714ec1b712de8c91a3352ce7e1";
    
    home-manager = {
      url = "github:nix-community/home-manager/7fb8678716c158642ac42f9ff7a18c0800fea551";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    hyprland = {
      url = "github:hyprwm/Hyprland/v0.46.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Add your neovim flake
    nvim-flake = {
      url = "github:CameronBadman/Nvim-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  
  outputs = { self, nixpkgs, home-manager, sops-nix, hyprland, nvim-flake, ... }@inputs:
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
            
            # Hyprland module
            hyprland.nixosModules.default
            
            # Home Manager module
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = { inherit inputs; };
                
                users.cameron = { pkgs, ... }: {
                  imports = [ 
                    ./hosts/hyprland/home.nix 
                  ];
                  home.packages = [ inputs.nvim-flake.packages.${system}.default ];
                };
              };
            }
            
            ./users
            
            # SOPS Nix module for secrets management
            sops-nix.nixosModules.sops
          ];
        };
      };
      
      # Default package for the system
      packages.${system}.default = 
        self.nixosConfigurations.nixos.config.system.build.toplevel;
    };
}
