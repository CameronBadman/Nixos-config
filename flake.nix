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
    nvim-config = {
      url = "github:CameronBadman/NixVim";
    };
    hyprland = {
      url = "github:hyprwm/Hyprland/v0.46.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self
    , nixpkgs
    , home-manager
    , sops-nix
    , nvim-config
    , hyprland
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
            hyprland.nixosModules.default
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.users.cameron = { pkgs, ... }: {
                imports = [ ./hosts/hyprland/home.nix ];
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
                };
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
