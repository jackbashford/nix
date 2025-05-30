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
    catppuccin.flavor = vars.flavor;

    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.grub.enable = true;
    boot.loader.grub.efiSupport = true;
    boot.loader.grub.device = "nodev";

    boot.kernelPackages = pkgs.linuxPackages_latest;
    boot.kernelModules = [ "uinput" ];

    hardware.uinput.enable = true;

    fonts = {
      packages = [
        pkgs.fira-code
        pkgs.nerd-fonts.fira-code
        pkgs.vistafonts
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

    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    services.displayManager.ly.enable = true;
    services.tailscale.enable = true;
    services.openssh.enable = true;

    services.globalprotect.enable = true;

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

    programs.java = {
      enable = true;
      package = pkgs.jdk23;
    };

    nixpkgs.config.allowUnfree = true;
    nix.settings.trusted-users = [
      "root"
      vars.user
    ];
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
      devenv
      digital
      gcc
      clang-manpages
      openocd
      gnumake
      zip
      unzip
      linux-manual
      man-pages
      man-pages-posix

      globalprotect-openconnect
      polkit_gnome
      networkmanagerapplet
      vlc
    ];

    # environment.etc.udev."rules.d"."60-openocd.rules".source =
    #   "${pkgs.openocd}/etc/udev/rules.d/60-openocd.rules";

    # services.udev.extraRules = ''
    #   ATTRS{idVendor}=="0d28", ATTRS{idProduct}=="0204", MODE="664"
    #   KERNEL=="hidraw*", ATTRS{idVendor}=="0d28", ATTRS{idProduct}=="0204", MODE="664"
    # '';

    services.udev.packages = with pkgs; [ openocd ];

    documentation = {
      enable = true;
      dev.enable = true;
      doc.enable = true;
      info.enable = true;
      man = {
        enable = true;
        # generateCaches = true;
      };
    };

    programs.nix-ld = {
      enable = true;
      libraries = [ pkgs.stdenv.cc.cc ];
    };
  };
}
