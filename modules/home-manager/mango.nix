{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.j.mango;
in
{
  options.j.mango = lib.mkEnableOption "Enable the mango window manager";

  imports = [
    inputs.noctalia.homeModules.default
    inputs.mangowm.hmModules.mango
  ];

  config = {
    home.packages = with pkgs; [
      ghostty
      grim
      slurp
      brightnessctl
      pulseaudio
    ];
    wayland.windowManager.mango = {
      enable = cfg;

      autostart_sh = "noctalia";
      settings = {
        bind =
          let
            basic = [
              "SUPER,Return,spawn,ghostty"
              "SUPER,d,spawn,noctalia msg panel-toggle launcher"
              "SUPER,space,togglefloating"
              "SUPER,f,togglefullscreen"
              "SUPER+SHIFT,q,killclient"
              "SUPER+SHIFT,c,reload_config"
              "SUPER+SHIFT,e,quit"
              "ALT+SHIFT,l,spawn,loginctl lock-session"
            ];
            focus = [
              "SUPER,h,focusdir,left"
              "SUPER,l,focusdir,right"
              "SUPER,k,focusdir,up"
              "SUPER,j,focusdir,down"
              "SUPER,0,view,0" # 0 is all tags
              "SUPER,1,view,1"
              "SUPER,2,view,2"
              "SUPER,3,view,3"
              "SUPER,4,view,4"
              "SUPER,5,view,5"
              "SUPER,6,view,6"
              "SUPER,7,view,7"
              "SUPER,8,view,8"
              "SUPER,9,view,9"
              "SUPER,GRAVE,view,-1" # -1 goes to previous tagset
            ];
            media = [
              "NONE,XF86MonBrightnessUp,spawn,brightnessctl s +10%"
              "NONE,XF86MonBrightnessDown,spawn,brightnessctl s 10%-"
              "NONE,XF86AudioRaiseVolume,spawn,pactl set-sink-volume @DEFAULT_SINK@ +1%"
              "NONE,XF86AudioLowerVolume,spawn,pactl set-sink-volume @DEFAULT_SINK@ -1%"
              "SHIFT,XF86AudioRaiseVolume,spawn,pactl set-sink-volume @DEFAULT_SINK@ +10%"
              "SHIFT,XF86AudioLowerVolume,spawn,pactl set-sink-volume @DEFAULT_SINK@ -10%"
              "SUPER,s,spawn,grim -g \"$(slurp)\""
            ];
            movement = [
              "SUPER+SHIFT,1,tagsilent,1"
              "SUPER+SHIFT,2,tagsilent,2"
              "SUPER+SHIFT,3,tagsilent,3"
              "SUPER+SHIFT,4,tagsilent,4"
              "SUPER+SHIFT,5,tagsilent,5"
              "SUPER+SHIFT,6,tagsilent,6"
              "SUPER+SHIFT,7,tagsilent,7"
              "SUPER+SHIFT,8,tagsilent,8"
              "SUPER+SHIFT,9,tagsilent,9"
              "SUPER+SHIFT,h,exchange_client,left"
              "SUPER+SHIFT,l,exchange_client,right"
              "SUPER+SHIFT,k,exchange_client,up"
              "SUPER+SHIFT,j,exchange_client,down"
            ];
          in
          basic ++ focus ++ media ++ movement;
        gesturebind = [
          "none,left,3,focusdir,left"
          "none,right,3,focusdir,right"
          "none,up,3,focusdir,up"
          "none,down,3,focusdir,down"
          "none,left,4,viewtoleft_have_client"
          "none,right,4,viewtoright_have_client"
          "none,up,4,toggleoverview"
          "none,down,4,toggleoverview"
        ];
        border_radius = 12;
      };
    };

    programs.noctalia = {
      enable = true;
      systemd.enable = true;

      settings = {
        theme = {
          mode = "dark";
          source = "builtin";
          builtin = "Catppuccin";
        };

        wallpaper = {
          enabled = true;
          default.path = "~/fuji-bg-cropped.webp";
        };

        widget = {
          workspaces = {
            hide_when_empty = true;
          };
          network = {
            show_label = false;
          };
        };

        bar = {
          main = {
            margin_ends = 0;
            margin_edge = 0;
            capsule = true;
            background_opacity = 0.0;
            start = [ "workspaces" ];
            center = [ "clock" ];
            end = [
              "tray"
              "notifications"
              "network"
              "battery"
            ];
          };
        };
      };
    };
  };
}
