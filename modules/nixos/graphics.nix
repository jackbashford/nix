{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.j.graphics;
in
{
  options.j.graphics = {
    enable = lib.mkEnableOption "Enable hardware accelerated graphics drivers";
    nvidia = lib.mkEnableOption "Enable NVIDIA drivers";
  };

  config = {
    hardware.graphics.enable = cfg.enable;
    hardware.nvidia = lib.mkIf (cfg.enable && cfg.nvidia) {
      modesetting.enable = true;
      nvidiaSettings = true;
    };
    services.xserver.videoDrivers = [
      "nvidia"
    ];
  };
}
