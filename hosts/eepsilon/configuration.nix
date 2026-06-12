{
  config,
  inputs,
  vars,
  pkgs,
  lib,
  ...
}:
let
  stm32pkgs = import inputs.stm32cubeide {
    system = "x86_64-linux";
    config.allowUnfree = true;
  };
in
{
  imports = [
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.home-manager
    ../../modules/nixos
  ];

  # boot.initrd.systemd.network.wait-online.enable = false;
  # boot.initrd.systemd.network.wait-online.anyInterface = true;

  boot.kernelParams = [
    #   "nohz=on"
    #   "nohz_full=0-15"
    "kvm.enable_virt_at_load=0"
  ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };

  programs.wireshark.enable = true;

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "vscode"
      "posy-cursors"
      "stm32cubeide"
    ];

  j = {
    keyboard = {
      enable = true;
      caps = true;
      gmeta = true;
      dlayer = true;
    };
    graphics.enable = true;
    xilinx-udev.enable = true; # not just xilinx udev but also stm32 udev
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.sessionVariables._JAVA_AWT_WM_NONREPARENTING = "1";
  environment.sessionVariables._JAVA_OPTIONS = "-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true";

  networking.hostName = "eepsilon";

  services.power-profiles-daemon.enable = true;

  services.fprintd = {
    enable = true;
  };

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      swt
    ];
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  services.blueman.enable = true;

  services.fwupd.enable = true;

  # In case sway dies :3
  services.desktopManager.plasma6.enable = true;

  programs.sway.enable = true;

  users.users."${vars.user}" = {
    isNormalUser = true;
    description = "${vars.user}";
    extraGroups = [
      "networkmanager"
      "wheel"
      # "plugdev"
      "docker"
      "wireshark"
      "vboxusers"
    ];
    shell = pkgs.zsh;
  };

  virtualisation.virtualbox.host.enable = true;

  home-manager = {
    extraSpecialArgs = {
      inherit inputs;
      vars = vars;
    };
    users.jack = import ./home.nix;
    backupFileExtension = "hm-bak";
  };

  environment.systemPackages =
    with pkgs;
    [
      fprintd
      powertop
      power-profiles-daemon
      swaynotificationcenter
      mako
      chromium
      acpi
      vscode
      wireshark
      libxcrypt-legacy
      ncurses5
    ]
    ++ ([ stm32pkgs.stm32cubeide_1_19_0 ]);

  services.logind = {
    enable = true;
    settings.Login = {
      HandlePowerKey = "sleep";
      HandlePowerKeyLongPress = "poweroff";
      HandleLidSwitch = "sleep";
    };
  };

  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
  };

  system.stateVersion = "24.11";
}
