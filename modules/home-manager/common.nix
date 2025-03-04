{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
{
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
      dark = true;
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
