{ config, pkgs, lib, ... }:

let utils = import ../../utils.nix { inherit lib; };
in {
  imports = utils.getImports ./.;

  environment.systemPackages = with pkgs; [
    # Languages
    nodejs
    python3
    python311Packages.pip
    poetry
    go
    luajit
    terraform

    # C/C++
    clang-tools

    # Rust
    cargo
    rustc
    rustfmt

    # Haskell
    ghc
    cabal-install
    stack

    # LSP Servers
    nodePackages.typescript
    nodePackages.typescript-language-server
    rust-analyzer
    gopls
    pyright
    lua-language-server
    nil
    jdt-language-server
    metals
    java-language-server
    sonarlint-ls
    jdk17

    #C#
    dotnet-sdk
  ];
}

