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
    j.dev.c = {
      enable = lib.mkEnableOption "Add C language support";
      helix = lib.mkEnableOption "Add Helix configuration";
    };
  };
  config = lib.mkIf cfg.dev.c.enable {
    home.packages = [
      pkgs.clang-tools
      pkgs.gf
    ];

    programs.helix.languages = lib.mkIf (cfg.helix.enable && cfg.dev.c.helix) {
      language = [
        {
          name = "c";
          auto-format = true;
          file-types = [
            "c"
            "h"
          ];
          indent = {
            tab-width = 2;
            unit = "  ";
          };
          formatter.command = "${pkgs.clang-tools}/bin/clang-format";
        }
      ];
    };
  };
}
