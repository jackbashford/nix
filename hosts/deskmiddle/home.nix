{
  config,
  pkgs,
  inputs,
  lib,
  vars,
  ...
}:
{
  imports = [
    inputs.catppuccin.homeModules.catppuccin
    ../../modules/home-manager
  ];

  home.username = "jack";
  home.homeDirectory = "/home/jack";

  catppuccin.flavor = vars.flavor;
  catppuccin.enable = true;
  catppuccin.zsh-syntax-highlighting.enable = false;

  j = {
    helix = {
      enable = true;
      defaultEditor = true;
      masterBranch = true;
    };
    dev.nix = {
      enable = true;
      helix = true;
    };
    i3 = {
      enable = true;
      extraCmds = [
        {
          command = "${pkgs.xorg.xrandr}/bin/xrandr --output DP-2 --mode 2560x1440 --rate 170.00 --output DP-0 --mode 2560x1440 --rate 165.00";
          always = true;
        }
      ];
    };
  };

  home.packages = [
    pkgs.pulseaudio
    pkgs.ghostty
    pkgs.rofi
    pkgs.flameshot

    pkgs.cntr

    pkgs.discord
    pkgs.spotify
    pkgs.chromium

    pkgs.jetbrains.idea-community
    pkgs.digital
  ];

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
        forwardAgent = true;
      };

    ghostty = {
      enable = true;
      settings = {
        font-family = "FiraCode Nerd Font";
        # font-feature = "ss09";
        confirm-close-surface = false;
        cursor-style = "bar";
        shell-integration-features = "no-cursor";
        gtk-single-instance = true;

        gtk-titlebar = false;
        window-decoration = false;
        window-theme = "ghostty";

        window-inherit-working-directory = false;
        working-directory = "home";
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
      '';

      shellAliases = {
        j = "zellij"; # depends on zellij
        # ls = "lsd -1"; # depends on lsd
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
    lsd.enable = true;
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
    zoxide.enable = true;
  };

  home.stateVersion = "24.11";

  programs.home-manager.enable = true;
}
