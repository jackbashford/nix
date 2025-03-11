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
      masterBranch = lib.mkEnableOption "Use the master branch as the source";
    };
  };
  config = lib.mkIf cfg.enable {
    programs.helix = {
      enable = true;
      package = lib.mkDefault inputs.helix.packages.${pkgs.hostPlatform.system}.default;
      defaultEditor = cfg.defaultEditor;
      settings = {
        editor = {
          line-number = "relative";
          color-modes = true;
          smart-tab.enable = false;
          soft-wrap.enable = true;
          cursor-shape = {
            insert = "block";
            normal = "block";
            select = "underline";
          };
          lsp.display-messages = true;
          search.smart-case = false;
        };

        keys = {
          normal = {
            X = [
              "extend_line_up"
              "extend_to_line_bounds"
            ];
            A-j = "insert_newline";
          };
          insert = {
            C-h = "signature_help";
          };
        };
      };
    };
  };
}
