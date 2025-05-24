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
    j.dev.typst = {
      enable = lib.mkEnableOption "Add Typst editing support";
      helix = lib.mkEnableOption "Add Helix configuration";
    };
  };
  config = lib.mkIf cfg.dev.typst.enable {
    home.packages = [
      pkgs.typst
      pkgs.tinymist
      pkgs.typstyle
    ];

    programs.helix.languages = lib.mkIf (cfg.helix.enable && cfg.dev.typst.helix) {
      language-server.tinymist = {
        command = "${pkgs.tinymist}/bin/tinymist";
        config = {
          exportPdf = "onSave";
        };
      };

      language = [
        {
          name = "typst";
          auto-format = true;
          file-types = [ "typ" ];
          indent = {
            tab-width = 2;
            unit = "  ";
          };
          formatter.command = "${pkgs.typstyle}/bin/typstyle";
          language-servers = [ "tinymist" ];
        }
      ];
    };
  };
}
