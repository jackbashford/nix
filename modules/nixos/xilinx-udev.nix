{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.j.xilinx-udev;
in
{
  options.j.xilinx-udev = {
    enable = lib.mkEnableOption "Enable Xilinx udev rules";
  };

  config = lib.mkIf cfg.enable {
    services.udev.packages = [
      (pkgs.writeTextFile {
        name = "52-digilent-usb.rules";
        destination = "/etc/udev/rules.d/52-xilinx-digilent-usb.rules";
        text = ''
          ATTRS{idVendor}=="1443", MODE:="666"
          ACTION=="add", ATTRS{idVendor}=="0403", ATTRS{manufacturer}=="Digilent", MODE:="666"
        '';
      })
      (pkgs.writeTextFile {
        name = "52-xilinx-ftdi-usb.rules";
        destination = "/etc/udev/rules.d/52-xilinx-ftdi-usb.rules";
        text = ''
          ACTION=="add", ATTRS{idVendor}=="0403", ATTRS{manufacturer}=="Xilinx", MODE:="666"
        '';
      })
      (pkgs.writeTextFile {
        name = "52-xilinx-pcusb.rules";
        destination = "/etc/udev/rules.d/52-xilinx-pcusb.rules";
        text = ''
          ATTR{idVendor}=="03fd", ATTR{idProduct}=="0008", MODE="666"
          ATTR{idVendor}=="03fd", ATTR{idProduct}=="0007", MODE="666"
          ATTR{idVendor}=="03fd", ATTR{idProduct}=="0009", MODE="666"
          ATTR{idVendor}=="03fd", ATTR{idProduct}=="000d", MODE="666"
          ATTR{idVendor}=="03fd", ATTR{idProduct}=="000f", MODE="666"
          ATTR{idVendor}=="03fd", ATTR{idProduct}=="0013", MODE="666"
          ATTR{idVendor}=="03fd", ATTR{idProduct}=="0015", MODE="666"
        '';
      })
      (pkgs.writeTextFile {
        name = "49-stlinkv2.rules";
        destination = "/etc/udev/rules.d/49-stlinkv2.rules";
        text = ''
          SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="3748", MODE="660", TAG+="uaccess", ENV{ID_MM_DEVICE_IGNORE}="1", SYMLINK+="stlinkv2_%n"
        '';
      })
      (pkgs.writeTextFile {
        name = "49-stlinkv1.rules";
        destination = "/etc/udev/rules.d/49-stlinkv1.rules";
        text = ''
          SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="3744", MODE="660", TAG+="uaccess", ENV{ID_MM_DEVICE_IGNORE}="1", SYMLINK+="stlinkv1_%n"
        '';
      })
      (pkgs.writeTextFile {
        name = "49-stlinkv2-1.rules";
        destination = "/etc/udev/rules.d/49-stlinkv2-1.rules";
        text = ''
          SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="374b", MODE="660", TAG+="uaccess", ENV{ID_MM_DEVICE_IGNORE}="1", SYMLINK+="stlinkv2-1_%n"

          SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="3752", MODE="660", TAG+="uaccess", ENV{ID_MM_DEVICE_IGNORE}="1", SYMLINK+="stlinkv2-1_%n"
        '';
      })
      (pkgs.writeTextFile {
        name = "49-stlinkv3.rules";
        destination = "/etc/udev/rules.d/49-stlinkv3.rules";
        text = ''
          SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="374d", MODE="660", TAG+="uaccess", ENV{ID_MM_DEVICE_IGNORE}="1", SYMLINK+="stlinkv3loader_%n"

          SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="374e", MODE="660", TAG+="uaccess", ENV{ID_MM_DEVICE_IGNORE}="1", SYMLINK+="stlinkv3_%n"

          SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="374f", MODE="660", TAG+="uaccess", ENV{ID_MM_DEVICE_IGNORE}="1", SYMLINK+="stlinkv3_%n"

          SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="3753", MODE="660", TAG+="uaccess", ENV{ID_MM_DEVICE_IGNORE}="1", SYMLINK+="stlinkv3_%n"

          SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="3754", MODE="660", TAG+="uaccess", ENV{ID_MM_DEVICE_IGNORE}="1", SYMLINK+="stlinkv3_%n"

          SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="3755", MODE="660", TAG+="uaccess", ENV{ID_MM_DEVICE_IGNORE}="1", SYMLINK+="stlinkv3loader_%n"

          SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="3757", MODE="660", TAG+="uaccess", ENV{ID_MM_DEVICE_IGNORE}="1", SYMLINK+="stlinkv3_%n"
        '';
      })
    ];
  };
}
