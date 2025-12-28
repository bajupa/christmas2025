{
  description = "Asist Development Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default";
    bun2nix.url = "github:nix-community/bun2nix?tag=2.0.6";
    bun2nix.inputs.nixpkgs.follows = "nixpkgs";
    bun2nix.inputs.systems.follows = "systems";
  };

  outputs =
    {
      nixpkgs,
      systems,
      bun2nix,
      ...
    }:
    let
      system = "x86_64-linux"; # or your system architecture
      pkgs = nixpkgs.legacyPackages.${system};
      eachSystem =
        f:
        nixpkgs.lib.genAttrs (import systems) (
          system: f (nixpkgs.legacyPackages.${system}.extend bun2nix.overlays.default)
        );

      build_web = { pkgs }: pkgs.callPackage ./default.nix { };
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        name = "asist";
        buildInputs = with pkgs; [
          bun
          bun2nix.packages.${system}.default
        ];
      };

      packages = eachSystem (pkgs: {
        default = build_web {
          pkgs = pkgs;
        };
      });
    };
}
