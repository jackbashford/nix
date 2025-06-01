{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.j;
in
{
  options = {
    j.dev.python = {
      enable = lib.mkEnableOption "Add Python language support";
      helix = lib.mkEnableOption "Add Helix configuration";
    };
  };
  config = lib.mkIf cfg.dev.python.enable {
    home.packages = [
      pkgs.python312Packages.python-lsp-server
      pkgs.ruff
    ];

    programs.helix.languages = lib.mkIf (cfg.helix.enable && cfg.dev.python.helix) {
      language-server.ruff = {
        command = "${pkgs.ruff}/bin/ruff";
        args = [ "server" ];
      };
      language = [
        {
          name = "python";
          auto-format = true;
          file-types = [
            "py"
          ];
          indent = {
            tab-width = 4;
            unit = "    ";
          };
          language-servers = [
            "ruff"
            "pylsp"
          ];
          formatter = {
            command = "${pkgs.ruff}/bin/ruff";
            args = [
              "format"
              "--silent"
              "-"
            ];
          };
        }
      ];
    };
  };
}
