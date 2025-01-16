{ config, pkgs, lib, ... }:

let
  utils = import ../../utils.nix { inherit lib; };
in
{
  imports = utils.getImports ./.;

  environment.systemPackages = with pkgs; [
    docker
    docker-compose
    kubernetes-helm
    kubectl
    minikube
  ];
}

