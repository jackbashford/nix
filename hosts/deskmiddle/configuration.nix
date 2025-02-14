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

  # Enable if you want to see Windows (or other OSes you may install) in future
  # boot.loader.grub.useOSProber = true;

  j = {
    keyboard = {
      enable = true;
      caps = true;
      gmeta = true;
      dlayer = true;
    };
    graphics = {
      nvidia = true;
      enable = true;
    };
  };

  networking.hostName = "deskmiddle";

  services.xserver = {
    enable = true;
    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        i3status
      ];
    };
    xrandrHeads = [
      {
        output = "DP-2";
        primary = true;
      }
      {
        output = "DP-1";
      }
    ];
    xkb = {
      layout = "au";
      variant = "";
    };
  };

  services.cron = {
    enable = true;
    systemCronJobs = [
      "0 * * * * jack cp $HOME/.zsh_history $HOME/.cache/zsh_history"
    ];
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

  home-manager = {
    extraSpecialArgs = {
      inherit inputs;
      vars = vars;
    };
    users.jack = import ./home.nix;
    backupFileExtension = "hm-bak";
  };

  system.stateVersion = "24.11";
}
