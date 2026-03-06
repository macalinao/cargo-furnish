{
  craneLib,
  pkgs,
}:
let
  inherit (pkgs) lib;

  src =
    let
      readmeFilter = path: _type: (builtins.match ".*README\\.md$" path) != null;
    in
    lib.cleanSourceWith {
      src = ../.;
      filter = path: type: (craneLib.filterCargoSources path type) || (readmeFilter path type);
    };

  meta = craneLib.crateNameFromCargoToml { cargoToml = ../crates/cargo-furnish/Cargo.toml; };

  commonArgs = {
    inherit src;
    inherit (meta) pname version;
    strictDeps = true;
  };

  cargoArtifacts = craneLib.buildDepsOnly commonArgs;

  cargo-furnish = craneLib.buildPackage (
    commonArgs
    // {
      inherit cargoArtifacts;
      cargoExtraArgs = "-p cargo-furnish";
      postInstall = ''
        installShellCompletion --cmd cargo-furnish \
          --bash <($out/bin/cargo-furnish --bpaf-complete-style-bash) \
          --zsh <($out/bin/cargo-furnish --bpaf-complete-style-zsh) \
          --fish <($out/bin/cargo-furnish --bpaf-complete-style-fish)
        $out/bin/cargo-furnish man > cargo-furnish.1
        installManPage cargo-furnish.1
      '';
      nativeBuildInputs = [ pkgs.installShellFiles ];
    }
  );
in
{
  inherit cargo-furnish;
  default = cargo-furnish;
}
