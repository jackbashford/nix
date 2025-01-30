{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.j.keyboard;
  tap-time = "150";
  hold-time = "200";
in
{
  options.j.keyboard = {
    enable = lib.mkEnableOption "Enable keyboard remapping (kanata)";
    caps = lib.mkEnableOption "Capslock modtap";
    gmeta = lib.mkEnableOption "G as meta";
    dlayer = lib.mkEnableOption "Custom D Layer";
  };

  config = lib.mkIf cfg.enable {
    services.kanata.enable = true;
    services.kanata.keyboards.default = {
      extraDefCfg = "process-unmapped-keys yes";
      config = ''
        (defsrc 
          ${lib.optionalString cfg.caps "caps"}
          ${lib.optionalString cfg.gmeta "g"}
          ${lib.optionalString cfg.dlayer "d h j k l f n w b"}
        )

        (defalias
          ${lib.optionalString cfg.caps "caps (tap-hold ${tap-time} ${hold-time} esc lctl)"}
          ${lib.optionalString cfg.gmeta "g (tap-hold ${tap-time} ${hold-time} g lmet)"}
          ${lib.optionalString cfg.dlayer "d (tap-hold  ${tap-time} ${hold-time} d (layer-while-held dlayer))"}
        )

        (deflayer base 
          ${lib.optionalString cfg.caps "@caps"}
          ${lib.optionalString cfg.gmeta "@g"}
          ${lib.optionalString cfg.dlayer "@d _ _ _ _ _ _ _ _"}
        )

        ${lib.optionalString cfg.dlayer ''
          (deflayer dlayer
            ${lib.optionalString cfg.caps "_"}
            ${lib.optionalString cfg.gmeta "_"}
            _ left down up right f bspc (macro C-right) (macro C-left)
          )
        ''}
      '';
    };
  };
}
