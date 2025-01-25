{ config, pkgs, ... }: {
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
    gdb
    binutils
    gnumake
    cmake
    ninja
    texstudio
    texlive.combined.scheme-full
    age
    obsidian
    ffmpeg-full
    xxd
    nix-output-monitor
  ];

}
