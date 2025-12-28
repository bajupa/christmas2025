{
  stdenv,
  pkgs,
  ...
}:
stdenv.mkDerivation {
  pname = "christmas2025";
  version = "0.1.0";

  src = ./.;
  nativebuildinputs = [
    pkgs.bun2nix.hook
  ];

  bundeps = pkgs.bun2nix.fetchBunDeps {
    bunNix = ./bun.lock.nix;
  };

  buildPhase = ''
  bun run build
  '';

  installPhase = ''
    # mkdir -p $out
    # cp -r ./dist/* $out/
  '';
}
