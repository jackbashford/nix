{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
{
  imports = [
    inputs.catppuccin.homeManagerModules.catppuccin
  ];

  home.username = "jack";
  home.homeDirectory = "/home/jack";

  catppuccin.flavor = "macchiato";
  catppuccin.enable = true;
  catppuccin.zsh-syntax-highlighting.enable = false;

  home.packages = [
    pkgs.ghostty

    pkgs.nil
    pkgs.nixfmt-rfc-style

    pkgs.discord

    pkgs.gleam
    pkgs.erlang
  ];

  xsession.windowManager.i3 = {
    enable = true;
    config =
      let
        mod = "Mod4";
        mod2 = "Mod1";
        term = "${pkgs.ghostty}/bin/ghostty";
        left = "h";
        right = "l";
        up = "k";
        down = "j";
      in
      {
        modifier = mod;
        terminal = term;
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
            "--locked XF86AudioMute" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-mute \@DEFAULT_SINK@ toggle";
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
            command = "1password --silent";
          }
        ];
      };
  };

  wayland.windowManager.sway = {
    enable = false;
    extraOptions = [ "--unsupported-gpu" ];
    config =
      let
        mod = "Mod4";
        mod2 = "Mod1";
        term = "${pkgs.ghostty}/bin/ghostty";
        menu = "${pkgs.wmenu}/bin/wmenu-run";
      in
      {
        modifier = mod;
        terminal = term;
        menu = menu;
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
            "${mod2}+Shift+l" = "exec ${pkgs.swaylock}/bin/swaylock -f -c 000000";
            "--locked XF86AudioMute" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-mute \@DEFAULT_SINK@ toggle";
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
            command = "1password --silent";
          }
        ];
      };
  };

  services.swayidle =
    let
      swaylock = "${pkgs.swaylock}/bin/swaylock";
      swaymsg = "${pkgs.sway}/bin/swaymsg";
    in
    {
      enable = true;
      timeouts = [
        {
          timeout = 300;
          command = "${swaylock} -f -c 000000";
        }
        {
          timeout = 600;
          command = "${swaymsg} \"output * power off\"";
          resumeCommand = "${swaymsg} \"output * power on\"";
        }
      ];
      events = [
        {
          event = "before-sleep";
          command = "${swaylock} -f -c 000000";
        }
      ];
    };

  programs = {
    git = {
      enable = true;
      userEmail = "jack@jackbashford.com";
      userName = "Jack Bashford";
    };

    ssh =
      let
        onePassPath = "~/.1password/agent.sock";
      in
      {
        enable = true;
        extraConfig = ''
          Host *
              IdentityAgent ${onePassPath}
        '';
      };

    ghostty = {
      enable = true;
      settings = {
        confirm-close-surface = false;
        cursor-style = "bar";
        gtk-single-instance = true;
        gtk-titlebar = false;
        shell-integration-features = "no-cursor";
        window-decoration = true;
        window-theme = "ghostty";
        working-directory = "home";
      };
    };

    zsh = {
      enable = true;
      autocd = true;
      autosuggestion.enable = true;
      enableCompletion = true;
      syntaxHighlighting = {
        enable = true;
        highlighters = [
          "brackets"
          "cursor"
        ];
      };

      history = {
        append = true;
        ignoreDups = true;
        save = 1000000;
        size = 1000000;
      };

      initExtra = ''
        setopt INC_APPEND_HISTORY
        bindkey "^[[3~" delete-char
      '';

      shellAliases = {
        j = "zellij";
        ls = "lsd -1";
        cat = "bat";
      };
    };

    helix = {
      enable = true;
      defaultEditor = true;
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

        keys.normal = {
          X = [
            "extend_line_up"
            "extend_to_line_bounds"
          ];
        };
        keys.insert = {
          C-h = "signature_help";
        };
      };
      languages = {

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

    direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableZshIntegration = true;
    };

    bat = {
      enable = true;
    };
    fd = {
      enable = true;
      hidden = true;
    };
    fzf.enable = true;
    gitui = {
      enable = true;
      keyConfig = ''
        move_left: Some(( code: Char('h'), modifiers: "")),
        move_right: Some(( code: Char('l'), modifiers: "")),
        move_up: Some(( code: Char('k'), modifiers: "")),
        move_down: Some(( code: Char('j'), modifiers: "")),
      '';
    };
    lsd.enable = true;
    man.enable = true;
    ripgrep.enable = true;
    scmpuff = {
      enable = true;
      enableAliases = true;
      enableZshIntegration = true;
    };
    starship.enable = true;
    tealdeer.enable = true;
    zellij.enable = true;
    zoxide.enable = true;
  };

  home.stateVersion = "24.11";

  programs.home-manager.enable = true;
}
