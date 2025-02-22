{
  lib,
  config,
  pkgs,
  inputs,
  vars,
  ...
}:
{
  config = {
    catppuccin.enable = true;
    catppuccin.flavor = "macchiato";

    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.grub.enable = true;
    boot.loader.grub.efiSupport = true;
    boot.loader.grub.device = "nodev";

    boot.kernelPackages = pkgs.linuxPackages_latest;
    boot.kernelModules = [ "uinput" ];

    hardware.uinput.enable = true;

    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
    };

    services.blueman.enable = true;

    fonts = {
      packages = [
        pkgs.fira-code
        pkgs.nerd-fonts.fira-code
      ];
      fontDir.enable = true;
    };

    environment.etc.nixos-current.source = inputs.self.outPath;

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

    services.printing.enable = true;
    services.displayManager.ly.enable = true;
    services.tailscale.enable = true;
    services.openssh.enable = true;

    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    programs.zsh.enable = true;

    programs.firefox.enable = true;

    programs._1password.enable = true;
    programs._1password-gui = {
      enable = true;
      polkitPolicyOwners = [ vars.user ];
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
      btop
      nerd-fonts.fira-code
      javacc
      devenv
      digital
    ];
  };
}
