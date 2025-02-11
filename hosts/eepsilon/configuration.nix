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

  catppuccin.enable = true;
  catppuccin.flavor = "macchiato";

  # Bootloader.
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.device = "nodev";

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelModules = [ "uinput" ];

  hardware.uinput.enable = true;

  j = {
    keyboard = {
      enable = true;
      caps = true;
      gmeta = true;
      dlayer = true;
    };
    graphics.enable = true;
  };

  fonts = {
    packages = [
      pkgs.fira-code
      pkgs.nerd-fonts.fira-code
    ];
    fontDir.enable = true;
  };

  environment.etc.nixos-current.source = inputs.self.outPath;
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.sessionVariables.ELECTRON_OZONE_PLATFORM_HINT = "wayland";

  networking.hostName = "eepsilon";
  networking.networkmanager.enable = true;

  time.timeZone = "Australia/Sydney";
  i18n.defaultLocale = "en_GB.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_AU.UTF-8";
    LC_IDENTIFICATION = "en_AU.UTF-8";
    LC_MEASUREMENT = "en_AU.UTF-8";
    LC_MONETARY = "en_AU.UTF-8";
    LC_NAME = "en_AU.UTF-8";
    LC_NUMERIC = "en_AU.UTF-8";
    LC_PAPER = "en_AU.UTF-8";
    LC_TELEPHONE = "en_AU.UTF-8";
    LC_TIME = "en_AU.UTF-8";
  };

  services.power-profiles-daemon.enable = true;

  services.fprintd = {
    enable = true;
  };

  services.printing.enable = true;
  services.fwupd.enable = true;

  # In case sway dies :3
  services.desktopManager.plasma6.enable = false;

  services.gnome.gnome-keyring.enable = true;
  programs.sway.enable = true;
  programs.sway.wrapperFeatures.gtk = true;

  services.displayManager.ly.enable = true;

  # services.displayManager.sddm.enable = true;
  # services.displayManager.sddm.wayland.enable = true;
  # services.displayManager.sddm.package = pkgs.kdePackages.sddm;
  # security.pam.services.sddm.enableGnomeKeyring = true;

  services.tailscale.enable = true;

  services.cron = {
    enable = true;
    systemCronJobs = [
      "0 * * * * jack cp $HOME/.zsh_history $HOME/.cache/zsh_history_git && git -C $HOME/.cache/zsh_history_git add . && git -C $HOME/.cache/zsh_history_git commit -m 'history backup'"
    ];
  };

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users.jack = {
    isNormalUser = true;
    description = "Jack";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;

  home-manager = {
    extraSpecialArgs = {
      inherit inputs;
      vars = vars;
    };
    users.jack = import ./home.nix;
    backupFileExtension = "hm-bak";
  };

  programs.firefox.enable = true;

  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "jack" ];
  };

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    htop
    fprintd
    nerd-fonts.fira-code
    powertop
    power-profiles-daemon
    # jetbrains-toolbox
    javacc
    swaynotificationcenter
  ];

  services.openssh.enable = true;

  system.stateVersion = "24.11";
}
