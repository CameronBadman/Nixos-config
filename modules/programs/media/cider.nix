{ pkgs, ... }:

let
  # Path to the AppImage in the Nix store
  ciderAppImage =
    /nix/store/60xa8xjbdaf33ic04w5smhjjy0c5bgnm-cider-linux-x64.AppImage;

  # Create a wrapper for the AppImage using appimage-run
  cider-2 = pkgs.writeShellScriptBin "cider-2" ''
    ${pkgs.appimage-run}/bin/appimage-run ${ciderAppImage}
  '';
in cider-2
