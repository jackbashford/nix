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

  config = lib.mkIf cfg.enable {
    hardware.graphics.enable = true;
    hardware.nvidia = lib.mkIf cfg.nvidia {
      modesetting.enable = true;
      nvidiaSettings = true;
    };
    services.xserver.videoDrivers = lib.mkIf cfg.nvidia [
      "nvidia"
    ];
  };
}
