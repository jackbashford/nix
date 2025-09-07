{
  config,
  pkgs,
  inputs,
  lib,
  vars,
  ...
}:
{
  nixpkgs.config.allowUnfree = true;

  imports = [
    inputs.catppuccin.homeModules.catppuccin
    ../../modules/home-manager
  ];

  home.username = "jack";
  home.homeDirectory = "/home/jack";

  home.sessionPath = [ "$HOME/.local/bin" ];

  catppuccin.flavor = vars.flavor;
  catppuccin.enable = true;
  catppuccin.zsh-syntax-highlighting.enable = false;
  catppuccin.fzf.enable = true;
  catppuccin.fzf.flavor = vars.flavor;
  catppuccin.fzf.accent = "pink";

  home.packages = with pkgs; [
    pulseaudio
    ghostty
    rofi
    flameshot

    cntr

    jetbrains.idea-community
    onlyoffice-desktopeditors
    vscodium

    font-awesome
    noto-fonts-emoji

    obs-studio
    kdePackages.okular
    zathura
    wl-clipboard
    hledger
  ];

  # home.pointerCursor = {
  #   gtk.enable = true;
  #   package = pkgs.posy-cursors;
  #   name = "Posy_Cursor_Black";
  #   size = 22;
  # };

  programs.wofi.enable = true;

  wayland.windowManager.sway = {
    enable = true;
    checkConfig = false;
    config =
      let
        mod = "Mod4";
        mod2 = "Mod1";
        term = "${pkgs.ghostty}/bin/ghostty";
        menu = "${pkgs.wofi}/bin/wofi --show drun";
      in
      {
        modifier = mod;
        terminal = term;
        menu = menu;
        input = {
          "type:touchpad" = {
            tap = "enabled";
          };
        };
        focus.followMouse = false;
        workspaceAutoBackAndForth = true;
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
                "${mod}+v"
                "${mod}+w"
              ]
          ))
          # ... and add the good ones!
          // {
            "${mod2}+Shift+l" = "exec ${pkgs.swaylock}/bin/swaylock -f -c 000000";
            "${mod}+s" = "exec ${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\"";
            "--locked XF86AudioMute" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-mute \@DEFAULT_SINK@ toggle";
            "XF86AudioRaiseVolume" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ +10%";
            "Shift+XF86AudioRaiseVolume" =
              "exec ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ +1%";
            "XF86AudioLowerVolume" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ -10%";
            "Shift+XF86AudioLowerVolume" =
              "exec ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ -1%";
            "XF86AudioMute" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle";
            "XF86MonBrightnessUp" = "exec ${pkgs.brightnessctl}/bin/brightnessctl set 5%+";
            "XF86MonBrightnessDown" = "exec ${pkgs.brightnessctl}/bin/brightnessctl set 5%-";
            "XF86AudioMedia" = "exec ${pkgs.sway}/bin/swaymsg output \"eDP-1\" power toggle";
          }
        );
        bars = [
          # {
          #   position = "top";
          #   command = "waybar";
          # }
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
          # {
          #   position = "top";
          #   colors = {
          #     statusline = "#ffffff";
          #     background = "#323232";
          #   };
          #   statusCommand = "while acpi; do sleep 60; done";
          # }
        ];
        startup = [
          {
            command = "swaymsg output eDP-1 scale 1.25";
            always = true;
          }
          {
            command = "1password --silent";
          }
          {
            command = "${pkgs.mako}/bin/mako";
            always = true;
          }
        ];
      };
    extraConfig = ''
      output "*" bg /home/${vars.user}/.background-image fill
    '';
  };

  programs.i3blocks = {
    enable = true;
    bars = {
      top = {
        bat = {
          command = "acpi | awk '{print $4}' | tr -d \,";
          interval = 5;
        };
        time = lib.hm.dag.entryAfter [ "bat" ] {
          command = "date";
          interval = 1;
        };
      };
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
          command = "${swaylock} -f -c 000000 && ${swaymsg} \"output * power off\"";
          resumeCommand = "${swaymsg} \"output * power on\"";
        }
      ];
      events = [
        {
          event = "before-sleep";
          command = "${swaylock} -f -c 000000";
        }
        {
          event = "lock";
          command = "${swaylock} -f -c 000000";
        }
      ];
    };

  programs = {
    git = {
      enable = true;
      userEmail = "jack@jackbashford.com";
      userName = "Jack Bashford";
      extraConfig = {
        init.defaultBranch = "main";
        credential.helper = "cache";
      };
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
        font-family = "FiraCode Nerd Font";
        font-feature = "ss09";
        font-size = 11;
        confirm-close-surface = false;
        cursor-style = "bar";
        shell-integration-features = "no-cursor";
        gtk-single-instance = true;

        gtk-titlebar = false;
        window-decoration = false;
        window-theme = "ghostty";

        window-inherit-working-directory = false;
        working-directory = "home";
        macos-option-as-alt = "left";
        custom-shader = null;
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

      initContent = ''
        setopt INC_APPEND_HISTORY
        bindkey "^[[3~" delete-char
        bindkey "^[[1;5C" forward-word
        bindkey "^[[1;5D" backward-word
      '';

      shellAliases = {
        j = "zellij"; # depends on zellij
        ls = "lsd -1"; # depends on lsd
        cat = "bat"; # depends on bat
        fzhx = "hx $(fzf)"; # depends on helix and fzf
      };
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
    lsd = {
      enable = true;
      enableZshIntegration = false;
    };
    man.enable = true;
    ripgrep.enable = true;
    scmpuff = {
      enable = true;
      enableAliases = true;
      enableZshIntegration = true;
    };
    starship = {
      enable = true;
      settings = {
        nix_shell.disabled = true;
      };
    };
    tealdeer = {
      enable = true;
      settings = {
        auto_update = true;
        auto_update_interval_hours = 24;
      };
    };
    tofi.enable = true;
    waybar.enable = true;
    zoxide.enable = true;

    zed-editor = {
      enable = true;
      extensions = [
        "java"
        "git-firefly"
        "make"
      ];
    };
  };

  home.sessionVariables = {
    # NIXOS_OZONE_WL = "1";
    # ELECTRON_OZONE_PLATFORM_HINT = "wayland";
    _JAVA_AWT_WM_NONREPARENTING = "1";
    _JAVA_OPTIONS = "-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true";
    LEDGER_FILE = "~/Documents/Finances/2025.journal";

  };

  home.stateVersion = "24.11";

  programs.home-manager.enable = true;

  # xdg.configFile = {
  #   "zellij/layouts/yazelix.kdl" = {
  #     text = ''
  #       layout {
  #         pane size=1 borderless=true {
  #           plugin location="zellij:tab-bar"
  #         }
  #         pane split_direction="vertical" {
  #           pane size="30%" {
  #             command "yazi"
  #           }
  #           pane split_direction="horizontal" {
  #             pane {
  #               command "hx"
  #               args "."
  #             }
  #             pane size="30%" {
  #               // Terminal pane for commands
  #             }
  #           }
  #         }
  #         pane size=2 borderless=true {
  #           plugin location="zellij:status-bar"
  #         }
  #       }
  #     '';
  #   };
  # };
}
