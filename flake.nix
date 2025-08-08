{
  description = "Cameron's NixOS Configuration";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # Remove flake-utils - it was only needed for openconnect-sso

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvim-flake = {
      url = "github:CameronBadman/Nvim-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
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
  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nvim-flake,
      zen-browser,
      desktop,
      users,
      hardware,
      # Remove openconnect-sso and flake-utils from outputs
      ...
    }@inputs:
    {
      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs self;
            inherit zen-browser;
            # Remove inherit openconnect-sso
          };
          modules = [
            # Allow unfree packages
            { nixpkgs.config.allowUnfree = true; }
            # Hardware and base configuration
            ./hardware-configuration.nix
            ./configuration.nix
            # Feature modules
            desktop.nixosModules.default
            hardware.nixosModules.default
            # Custom Neovim + Programming Language Toolchains
            (
              { pkgs, ... }:
              {
                environment.systemPackages = [
                  # Custom Neovim with LSP
                  inputs.nvim-flake.packages.x86_64-linux.default
                ]
                ++ (inputs.nvim-flake.extraPackages pkgs);
              }
            )
            # User configuration
            home-manager.nixosModules.home-manager
            users.nixosModules.default
          ];
        };
      };
    };
}
