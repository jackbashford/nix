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
    j.dev.markdown = lib.mkEnableOption "Add Markdown LSP support";
  };
  config = lib.mkIf cfg.dev.markdown {
    home.packages = [
      pkgs.marksman
    ];
  };
}
