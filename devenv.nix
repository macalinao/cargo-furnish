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
      dprint = {
        enable = true;
        includes = [
          "*.toml"
          "*.md"
          "*.json"
          "*.yaml"
          "*.yml"
        ];
        settings.plugins = pkgs.dprint-plugins.getPluginList (
          plugins: with plugins; [
            dprint-plugin-toml
            dprint-plugin-markdown
            dprint-plugin-json
            g-plane-pretty_yaml
          ]
        );
      };
      nixfmt.enable = true;
      rustfmt.enable = true;
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
