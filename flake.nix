{
  description = "Cameron's NixOS Configuration";
  
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    nur.url = "github:nix-community/NUR";
    
    nvim-flake = {
      url = "github:CameronBadman/Nvim-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    desktop = {
      url = "path:./flakes/desktop";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    users = {
      url = "path:./flakes/users";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    hardware = {
      url = "path:./flakes/hardware";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  
  outputs = {
    self,
    nixpkgs,
    home-manager,
    nvim-flake,
    desktop,
    users,
    hardware,
    nur,
    ...
  }@inputs: {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs self;
        };
        
        modules = [
          { 
            nixpkgs.config.allowUnfree = true;
            nixpkgs.overlays = [ nur.overlays.default ];
          }
          
          ./hardware-configuration.nix
          ./configuration.nix
          
          hardware.nixosModules.default
          desktop.nixosModules.default
          users.nixosModules.default
          
          ({ pkgs, ... }: {
            environment.systemPackages = [
              inputs.nvim-flake.packages.x86_64-linux.default
            ] ++ (inputs.nvim-flake.extraPackages pkgs);
          })
          
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.extraSpecialArgs = {
              inherit inputs;
            };
            
            home-manager.users.cameron = {
              imports = [
                desktop.homeManagerModules.default
                users.homeManagerModules.default
              ];
              
              home.stateVersion = "24.05";
              home.username = "cameron";
              home.homeDirectory = "/home/cameron";
            };
          }
        ];
      };
    };
  };
}
