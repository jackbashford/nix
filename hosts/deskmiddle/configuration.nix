# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  inputs,
  vars,
  pkgs,
  ...
}:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.home-manager
  ];

  # Bootloader.
  # boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.device = "nodev";
  # Enable if you want to see Windows (or other OSes you may install) in future
  # boot.loader.grub.useOSProber = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;
  # boot.kernelModules = [ "uinput" ];

  # hardware.uinput.enable = true;

  services.kanata = {
    enable = true;
    keyboards.default = {
      extraDefCfg = "process-unmapped-keys yes";
      config = ''
        (defsrc caps)

        (deflayer base esc)
      '';
    };
  };

  services.autorandr = {
    enable = true;
    profiles.default = {
      fingerprint = {
        DP-1 = "00ffffffffffff005a633ab701010101
                021f0104a53c21783fcd25a3574b9f27
                0d5054bfef80d1c0b300a940a9c09500
                904081808140565e00a0a0a029503020
                350056502100001a000000fd0030a5f3
                f344010a202020202020000000fc0056
                58323731382d324b50430a20000000ff
                0057414c3231303230333031350a0113
                02032cf15190050403021d1e1f141312
                1101292f3f4023090707830100006d1a
                0000020130a500000000000007fc0064
                a0a01e503020350056502100001a9add
                0078a0a01e503020350056502100001a
                abb80078a0a01e503020350056502100
                001afc9b0078a0a03250302035005650
                2100001a0000000000000000000000b2";
        DP-2 = "00ffffffffffff0005e3022783390000
                26200104b53c22783f29d5ad4f44a724
                0f5054bfef00d1c081803168317c4568
                457c6168617c565e00a0a0a029503020
                350055502100001e000000ff00584755
                4e394841303134373233000000fc0051
                3237473247335234420a2020000000fd
                0030aaffff44010a2020202020200283
                020332f14c0103051404131f12021190
                3f2309070783010000e305e301e60607
                016363006d1a0000020130aa00000000
                000098fc006aa0a01e50082035005550
                2100001a40e7006aa0a0675008209804
                55502100001a6fc200a0a0a055503020
                350055502100001ef03c00d051a03550
                60883a0055502100001c0000000000f3
                00ffffffffffff0005e3022783390000
                26200104b53c22783f29d5ad4f44a724
                0f5054bfef00d1c081803168317c4568
                457c6168617c565e00a0a0a029503020
                350055502100001e000000ff00584755
                4e394841303134373233000000fc0051
                3237473247335234420a2020000000fd
                0030aaffff44010a2020202020200283";
      };

      config = {
        DP-1 = {
          enable = true;
          primary = false;
          position = "2560x0";
          mode = "2560x1440";
          rate = "165.00";
        };
        DP-2 = {
          enable = true;
          primary = true;
          position = "0x0";
          mode = "2560x1440";
          rate = "165.00";
        };
      };
    };
  };

  environment.etc.nixos-current.source = inputs.self.outPath;

  networking.hostName = "deskmiddle"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Australia/Sydney";

  # Select internationalisation properties.
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

  services.xserver = {
    enable = true;
    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        i3status
      ];
    };
    displayManager = {
      lightdm.enable = true;
      defaultSession = "none+i3";
    };
  };

  programs.sway.enable = false;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "au";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # services.tailscale.enable = true;

  services.cron = {
    enable = true;
    systemCronJobs = [
      "0 * * * * jack cp $HOME/.zsh_history $HOME/.cache/zsh_history"
    ];
  };

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
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
  };

  # Install firefox.
  programs.firefox.enable = true;

  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "jack" ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    git
    htop
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
