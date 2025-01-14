{ config, lib, pkgs, ... }:

let
  cider = pkgs.stdenv.mkDerivation {
    name = "cider-2";
    version = "2.5.0";
    
    src = pkgs.fetchurl {
      url = "file://${builtins.getEnv "HOME"}/Downloads/cider-linux-x64.AppImage";
      sha256 = "ca16d4deeddc59c7be6b55c0d671d2f8590d3576c29c3afb0c1da8ba54fd7776";
    };

    nativeBuildInputs = [ pkgs.makeWrapper ];
    
    dontUnpack = true;
    
    installPhase = ''
      mkdir -p $out/bin
      cp $src $out/bin/cider
      chmod +x $out/bin/cider
    '';

    buildInputs = with pkgs; [
      alsa-lib     
      zlib
      cups
      dbus
      gtk3
      libpulseaudio
      nss
      xorg.libX11
      xorg.libXcomposite
      xorg.libXdamage
      xorg.libXext
      xorg.libXfixes
      xorg.libXrandr
      systemd
    ];
  };
in {
  environment.systemPackages = [ cider ];
}

