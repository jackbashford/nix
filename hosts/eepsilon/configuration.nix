{
  config,
  inputs,
  vars,
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.home-manager
    ../../modules/nixos
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
  # environment.sessionVariables.ELECTRON_OZONE_PLATFORM_HINT = "wayland";

  networking.hostName = "eepsilon";

  services.power-profiles-daemon.enable = true;

  services.fprintd = {
    enable = true;
  };

  services.fwupd.enable = true;

  # In case sway dies :3
  services.desktopManager.plasma6.enable = true;

  # services.gnome.gnome-keyring.enable = true;
  programs.sway.enable = true;
  # programs.sway.wrapperFeatures.gtk = true;

  # programs.nix-ld = {
  #   enable = true;
  #   libraries = [ ];
  # };

  services.cron = {
    enable = true;
    systemCronJobs = [
      "0 * * * * jack cp $HOME/.zsh_history $HOME/.cache/zsh_history_git && git -C $HOME/.cache/zsh_history_git add . && git -C $HOME/.cache/zsh_history_git commit -m 'history backup'"
    ];
  };

  # programs.ssh.setXAuthLocation = true;
  # programs.ssh.forwardX11 = true;

  users.users."${vars.user}" = {
    isNormalUser = true;
    description = "Jack";
    extraGroups = [
      "networkmanager"
      "wheel"
      "plugdev"
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
    fprintd
    powertop
    power-profiles-daemon
    swaynotificationcenter
    chromium
    # waypipe
    # xorg.xauth
  ];

  system.stateVersion = "24.11";
}
