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

  home.packages = with pkgs; [
    jabref
    dust
    pulseaudio
    ghostty
    rofi
    flameshot

    onlyoffice-desktopeditors
    vscodium

    font-awesome
    noto-fonts-color-emoji

    obs-studio
    kdePackages.okular
    wl-clipboard
    lazygit
    isabelle
    kdePackages.kwallet
    haskell.compiler.ghc912
    senpai
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
            "Shift+XF86AudioRaiseVolume" =
              "exec ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ +10%";
            "XF86AudioRaiseVolume" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ +1%";
            "Shift+XF86AudioLowerVolume" =
              "exec ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ -10%";
            "XF86AudioLowerVolume" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ -1%";
            "XF86AudioMute" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle";
            "XF86MonBrightnessUp" = "exec ${pkgs.brightnessctl}/bin/brightnessctl set 5%+";
            "XF86MonBrightnessDown" = "exec ${pkgs.brightnessctl}/bin/brightnessctl set 5%-";
            "XF86AudioMedia" =
              "exec ${pkgs.sway}/bin/swaymsg output \"*\" power off && ${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ true";
            "Shift+XF86AudioMedia" = "exec ${pkgs.sway}/bin/swaymsg output \"eDP-1\" power on";
            "Ctrl+Shift+XF86AudioMedia" = "exec ${pkgs.sway}/bin/swaymsg output \"*\" power on";
          }
        );
        bars = [ ];
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
    # extraConfig = ''
    #   output "*" bg /home/${vars.user}/.background-image fill
    # '';
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
      events = {
        "before-sleep" = "${swaylock} -f -c 000000";
        "lock" = "${swaylock} -f -c 000000";
      };
    };

  programs = {
    git = {
      enable = true;
      settings = {
        user.email = "jack@jackbashford.com";
        user.name = "Jack Bashford";
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
        enableDefaultConfig = false;
        matchBlocks."*" = {
          forwardAgent = false;
          addKeysToAgent = "no";
          compression = false;
          serverAliveInterval = 0;
          serverAliveCountMax = 3;
          hashKnownHosts = false;
          userKnownHostsFile = "~/.ssh/known_hosts";
          controlMaster = "no";
          controlPath = "~/.ssh/master-%r@%n:%p";
          controlPersist = "no";
        };
        extraConfig = ''
          Host *
            IdentityAgent ${onePassPath}
        '';
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
        	[[ "`seq 1 10 | shuf | head -1`" == 1 ]] && echo 'hewwo! ^_^' || true
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
    waybar.enable = true;
    zoxide.enable = true;
  };

  home.sessionVariables = {
    # NIXOS_OZONE_WL = "1";
    # ELECTRON_OZONE_PLATFORM_HINT = "wayland";
    _JAVA_AWT_WM_NONREPARENTING = "1";
    _JAVA_OPTIONS = "-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true";
    LEDGER_FILE = "~/Documents/Finances/2026.journal";
  };

  home.stateVersion = "24.11";

  programs.home-manager.enable = true;
}
