{
  description = "Advent of Code 2024 OCaml project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        ocamlPackages = pkgs.ocaml-ng.ocamlPackages_5_1;
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            ocamlPackages.ocaml
            ocamlPackages.dune_3
            ocamlPackages.findlib
            ocamlPackages.odoc
          ];
        };

        packages.default = ocamlPackages.buildDunePackage {
          pname = "aoc2024";
          version = "0.1.0";
          src = ./.;
          
          buildInputs = with ocamlPackages; [
            dune_3
          ];

          meta = {
            description = "Advent of Code 2024 solutions in OCaml";
            license = pkgs.lib.licenses.mit;
          };
        };

        apps.default = {
          type = "app";
          program = "${self.packages.${system}.default}/bin/aoc2024";
        };
      });
}