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
    dev.nix = {
      enable = true;
      helix = true;
    };
  };

  home.packages = [
    pkgs.pulseaudio
    pkgs.ghostty
    pkgs.flameshot

    pkgs.cntr
    pkgs.delta

    pkgs.discord
    pkgs.spotify
    pkgs.chromium

    pkgs.jetbrains.idea-community
    pkgs.jetbrains.idea-ultimate
    pkgs.jdk23
    pkgs.python39Full
    pkgs.digital
  ];

  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
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
    custom-shader = "ghostty-shaders/underwater.glsl";
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
