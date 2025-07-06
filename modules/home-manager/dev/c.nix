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
    j.dev.c = lib.mkEnableOption "Add C language support";
  };
  config = lib.mkIf cfg.dev.c {
    home.packages = [
      (pkgs.hiPrio pkgs.gcc)
      pkgs.clang-tools
      pkgs.gf
    ];

    programs.helix.languages = lib.mkIf cfg.helix.enable {
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
