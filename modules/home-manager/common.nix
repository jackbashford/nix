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
    helix = {
      enable = true;
      defaultEditor = true;
      masterBranch = true;
    };
    dev = {
      c = true;
      dafny = true;
      haskell = true;
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

    jetbrains.idea-community
    jdk23
    python311Full
    digital

    clang
    comma
  ];

  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
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

  programs.git.delta = {
    enable = true;
    options = {
      # dark = fals;
      line-numbers = true;
    };
  };

  programs.ghostty.settings = {
    gtk-adwaita = false;
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
}
