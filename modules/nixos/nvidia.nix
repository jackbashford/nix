{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.j.nvidia;
in
{
  options = {
    enable = lib.mkEnableOption "Enable NVIDIA drivers";
  };

  config = {
    hardware.nvidia = lib.mkIf cfg.enable {
      modesetting.enable = true;
      nvidiaSettings = true;
    };
    services.xserver.videoDrivers = [
      "nvidia"
    ];
  };
}
