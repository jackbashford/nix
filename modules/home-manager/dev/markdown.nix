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
    j.dev.markdown = {
      enable = lib.mkEnableOption "Add Markdown LSP support";
    };
  };
  config = lib.mkIf cfg.dev.typst.enable {
    home.packages = [
      pkgs.marksman
    ];
  };
}
