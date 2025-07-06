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
    j.dev.haskell = lib.mkEnableOption "Add Haskell language support";
  };
  config = lib.mkIf cfg.dev.haskell {
    home.packages = [
    ];

    # programs.helix.languages = lib.mkIf cfg.helix.enable {
    #   language = [
    #     {
    #       name = "haskell";
    #       auto-format = true;
    #       file-types = [
    #         "hs"
    #       ];
    #       indent = {
    #         tab-width = 2;
    #         unit = "  ";
    #       };

    #       formatter = {
    #         command = "${pkgs.fourmolu}/bin/fourmolu";
    #         args = [
    #           "--indentation=2"
    #           "--comma-style=leading"
    #           "--record-brace-space=true"
    #           "--indent-wheres=true"
    #           "--import-export-style=diff-friendly"
    #           "--respectful=true"
    #           "--haddock-style=multi-line"
    #           "--newlines-between-decls=1"
    #           "-o"
    #           "-XImportQualifiedPost"
    #           "--stdin-input-file"
    #           "%{buffer_name}"
    #         ];
    #       };
    #     }
    #   ];
    # };
  };
}
