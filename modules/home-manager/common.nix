{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
{
  home.sessionPath = [ "$HOME/.local/bin" ];

  catppuccin.enable = true;
  catppuccin.zsh-syntax-highlighting.enable = false;

  j = {
    mango = true;
    helix = {
      enable = true;
      defaultEditor = true;
      masterBranch = true;
    };
    dev = {
      c = true;
      dafny = false;
      haskell = true;
      json = true;
      markdown = true;
      nix = true;
      python = true;
      ts = true;
      typst = true;
    };
  };

  home.packages = with pkgs; [
    pulseaudio
    ghostty

    cntr
    delta

    python315
    digital

    clang
    comma

    nmh
    calcurse
    file
    glow
    hledger
    hledger-ui
    hledger-web
  ];

  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    shellWrapperName = "y";
  };

  programs.zellij = {
    enable = true;
    enableZshIntegration = false;
    settings = {
      default_layout = "compact";
      show_startup_tips = false;
      simplified_ui = true;
      show_release_notes = false;
      pane_frames = false;
      ui.pane_frames.hide_session_name = true;
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableZshIntegration = true;
    config = {
      hide_env_diff = true;
    };
  };

  programs.delta = {
    enableGitIntegration = true;
    enable = true;
    options = {
      line-numbers = true;
    };
  };

  wayland.windowManager.mango = {
    settings = {
      monitorrule = [
        "name:^eDP-1$,width:2256,height:1504,refresh:60,scale:1.2"
      ];
    };
  };

  gtk.gtk3.extraCss = ''
    .window-frame {
        box-shadow: 0 0 0 0;
        margin: 0;
    }
    window decoration {
        margin: 0;
        padding: 0;
        border: none;
    }
  '';

  gtk.gtk4.extraCss = ''
    .background {
        margin: 0;
        padding: 0;
        box-shadow: 0 0 0 0;
    }
  '';

  programs.firefox = {
    enable = true;
    nativeMessagingHosts = with pkgs; [
      gnome-browser-connector
      jabref
    ];
    configPath = ".mozilla/firefox";
  };
}
