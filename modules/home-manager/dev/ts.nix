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
    j.dev.ts = lib.mkEnableOption "Add TypeScript language support";
  };
  config = lib.mkIf cfg.dev.ts {
    home.packages = [
      pkgs.typescript-language-server
      pkgs.prettierd
    ];

    programs.helix.languages = lib.mkIf cfg.helix.enable {
      language = [
        {
          name = "typescript";
          auto-format = true;
          file-types = [
            "ts"
            "js"
          ];
          indent = {
            tab-width = 2;
            unit = "  ";
          };
          formatter = {
            command = "${pkgs.prettierd}/bin/prettierd";
            args = [
              "--stdin-filepath"
              "%{buffer_name}"
            ];
          };
        }
      ];
    };
  };
}
