{ pkgs ? import <nixpkgs> { system = builtins.currentSystem; }
, appimageTools ? pkgs.appimageTools, lib ? pkgs.lib, fetchurl ? pkgs.fetchurl
}:

appimageTools.wrapType2 rec {
  pname = "cider";
  version = "2.3.2";

  src = fetchurl {
    url =
      "file:///home/cameron/music/cider-linux-x64.AppImage"; # Update this path
    sha256 =
      "0xkpzmabma0x1kxkm762fqshsngqs9qxdh2mdfzcfnfwxpgd85na"; # Update this hash
  };

  extraInstallCommands = ''
    # Move the extracted AppImage binary to the correct location
    mv $out/bin/${pname}-${version} $out/bin/${pname} || true

    # Install desktop file and icons (if they exist)
    if [ -e ${pname}.desktop ]; then
      install -m 444 -D ${pname}.desktop -t $out/share/applications
      substituteInPlace $out/share/applications/${pname}.desktop \
        --replace 'Exec=AppRun' 'Exec=${pname}'
    fi

    if [ -d usr/share/icons ]; then
      cp -r usr/share/icons $out/share
    fi
  '';

  meta = with lib; {
    description =
      "A new look into listening and enjoying Apple Music in style and performance.";
    homepage = "https://cider.sh/";
    maintainers = [ maintainers.nicolaivds ];
    platforms = [ "x86_64-linux" ];
  };
}
