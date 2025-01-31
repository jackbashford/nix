{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.j.i3;
in
{
  options.j.i3 = {
    enable = lib.mkEnableOption "Enable the i3 window manager";
    extraCmds = lib.mkOption {
      type = with lib.types; listOf attrs;
      default = [ ];
      example = [
        {
          command = "${pkgs.discord}/bin/discord";
          always = true;
        }
      ];
      description = "A list of additional startup commands for i3";
    };
  };
  config = {

    xsession.windowManager.i3 = lib.mkIf cfg.enable {
      enable = true;
      config =
        let
          mod = "Mod4";
          mod2 = "Mod1";
          term = "${pkgs.ghostty}/bin/ghostty";
          menu = "${pkgs.rofi}/bin/rofi -show drun -no-lazy-grab";
          left = "h";
          right = "l";
          up = "k";
          down = "j";
        in
        {
          modifier = mod;
          terminal = term;
          menu = menu;
          workspaceAutoBackAndForth = true;
          window.hideEdgeBorders = "both";
          keybindings = lib.mkOptionDefault (
            # Remove the bad keybindings :p ...
            (builtins.listToAttrs (
              builtins.map
                (u: {
                  name = u;
                  value = null;
                })
                [
                  "${mod}+Left"
                  "${mod}+Right"
                  "${mod}+Up"
                  "${mod}+Down"
                  "${mod}+Shift+Left"
                  "${mod}+Shift+Right"
                  "${mod}+Shift+Up"
                  "${mod}+Shift+Down"
                  "${mod}+a"
                  "${mod}+b"
                  "${mod}+s"
                  "${mod}+v"
                  "${mod}+w"
                ]
            ))
            # ... and add the good ones!
            // {
              "${mod2}+Shift+l" = "exec ${pkgs.i3lock}/bin/i3lock -f -c 000000";
              "${mod}+${left}" = "focus left";
              "${mod}+${right}" = "focus right";
              "${mod}+${up}" = "focus up";
              "${mod}+${down}" = "focus down";
              "${mod}+Shift+${left}" = "move left";
              "${mod}+Shift+${right}" = "move right";
              "${mod}+Shift+${up}" = "move up";
              "${mod}+Shift+${down}" = "move down";
              "${mod}+s" = "exec ${pkgs.flameshot}/bin/flameshot gui -c";
              "${mod}+p" = "exec ${pkgs.flameshot}/bin/flameshot gui";
            }
          );
          bars = [
            {
              position = "top";
              colors = {
                statusline = "#ffffff";
                background = "#323232";
                # inactiveWorkspace = {
                #   background = "#32323200";
                #   border = "#32323200";
                #   text = "#5c5c5c";
                # };
              };
              statusCommand = "while date +'%Y-%m-%d %X'; do sleep 1; done";
            }
          ];
          startup = [
            {
              command = "${pkgs.flameshot}/bin/flameshot";
              always = true;
            }
            {
              command = "1password --silent";
            }
            {
              command = "--no-startup-id ${pkgs.xautolock}/bin/xautolock -time 5 -locker ${pkgs.i3lock}/bin/i3lock -c 000000";
            }
          ] ++ cfg.extraCmds;
        };
    };
  };
}
