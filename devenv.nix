{ pkgs, ... }:

{
  packages = with pkgs; [
    git
  ];

  languages.rust.enable = true;

  scripts.cargo-furnish.exec = ''
    cargo run --release -p cargo-furnish -- "$@"
  '';

  treefmt = {
    enable = true;
    config.programs = {
      nixfmt.enable = true;
      rustfmt.enable = true;
      oxfmt = {
        enable = true;
        includes = [
          "*.json"
          "*.md"
          "*.toml"
          "*.yaml"
          "*.yml"
        ];
      };
    };
  };

  git-hooks.hooks = {
    clippy = {
      enable = true;
      settings = {
        allFeatures = true;
        denyWarnings = true;
        extraArgs = "--all-targets";
      };
    };
    treefmt.enable = true;
  };
}
