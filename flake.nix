{
  description = "Cameron's NixOS Configuration";
  
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    nvim-flake = {
      url = "github:CameronBadman/Nvim-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # Add zen-browser flake
   zen-browser = {
  url = "github:MarceColl/zen-browser-flake";
  inputs.nixpkgs.follows = "nixpkgs";
};
    
    # Local flakes
    desktop = {
      url = "path:./flakes/desktop";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    users = {
      url = "path:./flakes/users";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    
    hardware = {
      url = "path:./flakes/hardware";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  
  outputs = { self, nixpkgs, home-manager, nvim-flake, zen-browser, desktop, users, hardware, ... }@inputs: {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs self; };
        
        modules = [
          # Allow unfree packages
          { nixpkgs.config.allowUnfree = true; }
          
          # Hardware and base configuration
          ./hardware-configuration.nix
          ./configuration.nix
          
          # Feature modules
          desktop.nixosModules.default
          hardware.nixosModules.default
          # REMOVED hyprland.nixosModules.default - using nixpkgs instead
          
          # Custom Neovim
          { environment.systemPackages = [
            inputs.nvim-flake.packages.x86_64-linux.default
            inputs.nvim-flake.packages.x86_64-linux.devPackages
          ]; }
          
          # User configuration
          home-manager.nixosModules.home-manager
          users.nixosModules.default
          
          # Secrets
        ];
      };
    };
  };
}
