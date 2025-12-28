{
  bun2nix,
  stdenv,
  ...
}:
stdenv.mkDerivation {
  pname = "christmas2025";
  version = "0.1.0";

  src = ./.;
  nativeBuildInputs = [
    bun2nix.hook
  ];

  bunDeps = bun2nix.fetchBunDeps {
    bunNix = ./bun.lock.nix;
  };

  buildPhase = ''
    bun run build
  '';

  installPhase = ''
    mkdir -p $out
    cp -r ./dist/* $out/
  '';
}
