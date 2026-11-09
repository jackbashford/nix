{
  config,
  inputs,
  vars,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.home-manager
    ../../modules/nixos
  ];

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

  security.pki.certificates = [
    ''
      -----BEGIN CERTIFICATE-----
      MIICFzCCAb6gAwIBAgIQVNwc1/mC12YD1qTNNTaHhTAKBggqhkjOPQQDAjAxMQ4w
      DAYDVQQKEwVtZXNoTzEfMB0GA1UEAxMWbWVzaE8gTWFuYWdlciBMb2NhbCBDQTAe
      Fw0yNjA5MDkwNjMwNTFaFw0yODA5MDgwNjMwNTFaMBcxFTATBgNVBAMTDE9jZWFu
      aWFzLU1CUDBZMBMGByqGSM49AgEGCCqGSM49AwEHA0IABG45rcKNYETjrfelRtoj
      kWFPDUEJG7IgKKO9CuCma0DI9LcBe7mtXDQYpqizu4FU+Nk9PtRnhgamCqtTnqNZ
      jr+jgdEwgc4wCQYDVR0TBAIwADAOBgNVHQ8BAf8EBAMCA4gwEwYDVR0lBAwwCgYI
      KwYBBQUHAwEwHQYDVR0OBBYEFJ4xKG5nIBuUPMMnJrfxT4IIQCaSMB8GA1UdIwQY
      MBaAFLiGeJuy0fVTkzwIIjttbYEDBm66MFwGA1UdEQRVMFOCDE9jZWFuaWFzLU1C
      UIIST2NlYW5pYXMtTUJQLmxvY2FsghhPY2Vhbmlhcy1NQlAubG9jYWxkb21haW6C
      CWxvY2FsaG9zdIcEfwAAAYcEwKgAMDAKBggqhkjOPQQDAgNHADBEAiBZttuusvqu
      jugCFcXqsnp7e/jgk9oahx9N9P+uNVAEHQIgY5US6LqUI+GOuwhbHYQToa2f3wIG
      XLQ9An1NhOopsF8=
      -----END CERTIFICATE-----''
  ];

  programs.wireshark.enable = true;

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "vscode"
      "posy-cursors"
    ];

  j = {
    keyboard = {
      enable = true;
      caps = true;
      gmeta = true;
      dlayer = true;
    };
    graphics.enable = true;
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.sessionVariables._JAVA_AWT_WM_NONREPARENTING = "1";
  environment.sessionVariables._JAVA_OPTIONS = "-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true";

  networking.hostName = "eepsilon";

  services.power-profiles-daemon.enable = true;

  services.fprintd = {
    enable = true;
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
      "docker"
      "wireshark"
      "vboxusers"
      "input"
    ];
    shell = pkgs.zsh;
  };

  home-manager = {
    extraSpecialArgs = {
      inherit inputs;
      vars = vars;
    };
    users.jack = import ./home.nix;
    backupFileExtension = "hm-bak";
  };

  environment.systemPackages = with pkgs; [
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
    dsda-doom
    dsda-launcher
  ];

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
