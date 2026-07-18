{
  lib,
  config,
  pkgs,
  inputs,
  vars,
  ...
}:
{
  imports = [
    inputs.mangowm.nixosModules.mango
  ];

  config = {
    catppuccin.enable = true;
    catppuccin.flavor = vars.flavor;

    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.grub.enable = true;
    boot.loader.grub.efiSupport = true;
    boot.loader.grub.device = "nodev";

    # boot.kernelPackages = pkgs.linuxPackages_latest;
    boot.kernelModules = [ "uinput" ];

    hardware.uinput.enable = true;

    fonts = {
      packages = with pkgs; [
        fira-code
        nerd-fonts.fira-code
        vista-fonts
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-color-emoji
        liberation_ttf
        fira-code
        fira-code-symbols
        mplus-outline-fonts.githubRelease
        dina-font
        proggyfonts
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
    services.printing.drivers = with pkgs; [
      hplip
      hplipWithPlugin
    ];

    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    services.displayManager.sddm.enable = true;
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

    # programs.firefox.enable = true;

    programs._1password.enable = true;
    programs._1password-gui = {
      enable = true;
      polkitPolicyOwners = [ vars.user ];
    };

    programs.java = {
      enable = true;
      package = pkgs.jdk25;
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

    programs.mango = {
      enable = true;
    };

    environment.systemPackages = with pkgs; [
      vim
      wget
      git
      htop
      btop
      nerd-fonts.fira-code
      devenv
      digital
      # gcc
      clang-manpages
      openocd
      gnumake
      zip
      unzip
      linux-manual
      man-pages
      man-pages-posix
      polkit_gnome
      networkmanagerapplet
      vlc
      gpclient
    ];

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

    nix.optimise.automatic = true;
    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };

    nix.settings = {
      extra-substituters = [ "https://noctalia.cachix.org" ];
      extra-trusted-public-keys = [
        "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
      ];
    };
  };
}
