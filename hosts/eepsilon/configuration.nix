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
    packages = [ pkgs.fira-code ];
    fontDir.enable = true;
  };

  environment.etc.nixos-current.source = inputs.self.outPath;

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

  # services.xserver = {
  #   enable = true;
  #   windowManager.i3 = {
  #     enable = true;
  #     extraPackages = with pkgs; [
  #       i3status
  #     ];
  #   };
  #   xkb = {
  #     layout = "au";
  #     variant = "";
  #   };
  # };

  services.fprintd.enable = true;

  programs.sway.enable = true;

  services.displayManager.ly.enable = true;

  services.tailscale.enable = true;

  services.cron = {
    enable = true;
    systemCronJobs = [
      "0 * * * * jack cp $HOME/.zsh_history $HOME/.cache/zsh_history"
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
  ];

  services.openssh.enable = true;

  system.stateVersion = "24.11";
}
