# private/flake.nix
{
  description = "Private NixOS configuration";

  outputs = { self }: {
    nixosModules = {
      networking = import ./networking.nix;
      default = import ./.;
    };
  };
}

