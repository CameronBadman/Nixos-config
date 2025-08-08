# flakes/users/flake.nix
{
  description = "User configuration for Cameron";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    {
      self,
      nixpkgs,
      home-manager,
    }:
    {
      nixosModules.default =
        {
          config,
          lib,
          pkgs,
          inputs,
          zen-browser,
          ...
        }:
        {
          # Accept zen-browser from specialArgs
          # Import all user modules
          imports = [
            ./modules/user.nix
            ./modules/packages.nix
          ];

          # Set directory permissions for user workspaces
          systemd.tmpfiles.rules = [
            # Ensure cameron owns the uni directory with proper permissions
            "d /uni 0755 cameron users - -"
            # Ensure cameron owns the projects directory with proper permissions
            "d /projects 0755 cameron users - -"
          ];
          # Home Manager configuration
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = {
              inherit inputs;
              inherit zen-browser; # Pass zen-browser to home-manager
            };
            users.cameron = {
              imports = [
                (import ./home)
                zen-browser.homeModules.twilight
              ];
            };
          };
        };
      nixosModules = {
        user = import ./modules/user.nix;
        packages = import ./modules/packages.nix;
      };
    };
}
