{ config, pkgs, lib, ... }:

let
  utils = import ../utils.nix { inherit lib; };
in
{
  imports = utils.getImports ./.;

  environment.systemPackages = with pkgs; [
    git
    ripgrep
    fd
    fzf
    bat
    delta
    tree-sitter
    p7zip
    unzip
    wget
    gcc
    gnumake
    cmake
    ninja
    texstudio
    texlive.combined.scheme-full
    age
  ];
}

