{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
{
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
