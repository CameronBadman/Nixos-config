{ pkgs, lib, ... }:
let utils = import ../../utils.nix { inherit lib; };
in {
  imports = utils.getImports ./.;
  environment.systemPackages = with pkgs; [
    # Python Environment
    python311
    python311Packages.pip
    python311Packages.opencv4 # OpenCV
    gtk3
    libGL
    python311Packages.numpy # Required for OpenCV
    python311Packages.tkinter
    poetry
    pyenv
    stdenv.cc.cc.lib
    libGLU
    xorg.libX11
    xorg.libXrender
    xorg.libX11.dev
    xorg.libXcursor
    xorg.libXi
    xorg.libXinerama
    xorg.libXrandr
    xorg.libXxf86vm
    libxkbcommon
    xorg.libXext
    mesa
    xorg.libxcb
    openssl
    icu
    zlib
    awscli2
    # Computer Vision Dependencies
    pkg-config
    cmake
    ffmpeg
    v4l-utils # Video for Linux utilities
    # Development Tools
    sqlite
    sqlc
    # Languages & Runtime
    nodejs
    go
    fyne
    luajit
    terraform
    # C/C++ Tools
    clang-tools
    gcc
    # Rust Tools
    cargo
    rustc
    rustfmt
    # Haskell Tools
    ghc
    cabal-install
    stack
    dafny
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
    go-critic
    # Java (updated to the latest LTS)
    jdk17
    maven
    gradle
    # Quarkus
    quarkus
    # PostgreSQL (for ORM)
    postgresql
    # Docker (for dev containers)
    docker
    docker-compose
    # Additional useful tools for Java/Quarkus dev
    graalvm-ce
    # .NET
    dotnet-sdk
  ];
  
  # Optional: Add environment variables if needed
  environment.variables = {   
    OPENCV_LOG_LEVEL = "INFO";
    DOTNET_SYSTEM_GLOBALIZATION_INVARIANT = "1"; 
    JAVA_HOME = "${pkgs.jdk17}";
    GRAALVM_HOME = "${pkgs.graalvm-ce}";
    PATH = [
      "$HOME/.quarkus/bin"
      "$JAVA_HOME/bin"
    ];
  };
  
  # Enable Docker service
  virtualisation.docker.enable = true;
  
}
