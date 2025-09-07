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
    j.dev.json = lib.mkEnableOption "Add JSON language support";
  };
  config = lib.mkIf cfg.dev.json {
    home.packages = [
      pkgs.jsonfmt
    ];

    programs.helix.languages = lib.mkIf cfg.helix.enable {
      language = [
        {
          name = "json";
          auto-format = true;
          file-types = [
            "json"
          ];
          indent = {
            tab-width = 2;
            unit = "  ";
          };
          formatter.command = "${pkgs.jsonfmt}/bin/jsonfmt";
        }
      ];
    };
  };
}
