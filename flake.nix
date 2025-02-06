{
  description = "NixOS Configuration";
  
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
    
    hyprland = {
      url = "github:hyprwm/Hyprland/v0.46.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  
  outputs = { self, nixpkgs, home-manager, sops-nix, hyprland, ... }@inputs:
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
                  
                  programs.neovim = {
                    enable = true;
                    defaultEditor = true;
                    viAlias = true;
                    vimAlias = true;
                    extraLuaConfig = ''
                      vim.opt.number = true
                      vim.opt.relativenumber = true
                      vim.opt.cursorline = true
                    '';
                    plugins = with pkgs.vimPlugins; [
                      telescope-nvim
                      plenary-nvim
                      neo-tree-nvim
                      nui-nvim
                      nvim-web-devicons
                      (nvim-treesitter.withPlugins (plugins: with plugins; [
                        lua
                        nix
                        python
                        javascript
                        typescript
                        rust
                      ]))
                    ];
                  };
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
