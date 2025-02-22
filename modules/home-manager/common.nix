{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
{
  programs.ghostty.settings.custom-shader = "ghostty-shaders/water.glsl";
}
