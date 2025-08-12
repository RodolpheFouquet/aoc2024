{
  description = "Advent of Code 2024 OCaml project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
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
            ocamlPackages.ppx_inline_test
            ocamlPackages.ppx_expect
          ];

          shellHook = ''
            echo "🎄 Advent of Code 2024 - OCaml Development Environment"
            echo "================================================"
            echo "Available commands:"
            echo "  dune build           - Build the project"
            echo "  dune exec aoc2024    - Run the main executable"
            echo "  dune test            - Run tests"
            echo "  dune runtest         - Run inline tests"
            echo "  dune clean           - Clean build artifacts"
            echo "  nix run              - Run via Nix"
            echo ""
          '';
        };

        packages.default = ocamlPackages.buildDunePackage {
          pname = "aoc2024";
          version = "0.1.0";
          src = ./.;

          buildInputs = with ocamlPackages; [
            dune_3
            ppx_inline_test
            ppx_expect
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
      }
    );
}

