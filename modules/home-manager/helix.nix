{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.j.helix;
in
{
  options = {
    j.helix = {
      enable = lib.mkEnableOption "Enable the Helix editor";
      defaultEditor = lib.mkEnableOption "Use Helix as the default editor";
      nix = lib.mkEnableOption "Add Nix editing support";
    };
  };
  config = lib.mkIf cfg.enable {
    programs.helix = {
      enable = true;
      defaultEditor = cfg.defaultEditor;
      settings = {
        editor = {
          line-number = "relative";
          color-modes = true;
          smart-tab.enable = false;
          soft-wrap.enable = true;
          cursor-shape = {
            insert = "bar";
            normal = "block";
            select = "underline";
          };
          lsp.display-messages = true;
        };

        keys = {
          normal = {
            X = [
              "extend_line_up"
              "extend_to_line_bounds"
            ];
          };
          insert = {
            C-h = "signature_help";
          };
        };
      };
    };
  };
}
