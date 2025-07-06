{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
{
  programs.ghostty = {
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
    };
  };

}
