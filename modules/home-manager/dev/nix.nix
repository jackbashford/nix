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
    j.dev.nix = {
      enable = lib.mkEnableOption "Add Nix editing support";
      helix = lib.mkEnableOption "Add Helix configuration";
    };
  };
  config = lib.mkIf cfg.dev.nix.enable {
    home.packages = [
      pkgs.nil
      pkgs.nixfmt-rfc-style
    ];

    programs.helix.languages = lib.mkIf (cfg.helix.enable && cfg.dev.nix.helix) {
      language-server.nil.command = "${pkgs.nil}/bin/nil";

      language = [
        {
          name = "nix";
          auto-format = true;
          file-types = [ "nix" ];
          indent = {
            tab-width = 2;
            unit = "  ";
          };
          formatter.command = "${pkgs.nixfmt-rfc-style}/bin/nixfmt";
          language-servers = [ "nil" ];
        }
      ];
    };
  };
}
