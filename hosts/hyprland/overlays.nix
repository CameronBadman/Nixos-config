# overlays.nix
final: prev: {
  aquamarine = prev.aquamarine.overrideAttrs (oldAttrs: {
    buildInputs = (oldAttrs.buildInputs or []) ++ [ 
      prev.mesa
      prev.mesa.dev
      prev.libglvnd
    ];
    nativeBuildInputs = (oldAttrs.nativeBuildInputs or []) ++ [
      prev.pkg-config
    ];
  });
}
