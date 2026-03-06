{
  description = "Furnish Rust crates with standardized Cargo.toml metadata, READMEs, and doc attributes";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    crane.url = "github:ipetkov/crane";
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";
  };

  outputs =
    inputs@{
      flake-parts,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      perSystem =
        {
          self',
          pkgs,
          ...
        }:
        let
          craneLib = inputs.crane.mkLib pkgs;

          packages = import ./nix/packages.nix {
            inherit craneLib pkgs;
          };
        in
        {
          checks = packages;

          packages = packages;

          devShells.default = craneLib.devShell {
            checks = self'.checks;
          };
        };
    };
}
