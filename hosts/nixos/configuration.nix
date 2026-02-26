# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  #Clean the disk weekly
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  #Clean the disk deleting duplicates
  nix.settings.auto-optimise-store = true;

  #Hyprland idle and lock
  programs.hyprlock.enable = true;

  services.hypridle = {
    enable = true;
  };

  #Flatpak, for Sober
  services.flatpak.enable = true;
  systemd.services.flatpak-repo = {
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    '';
  };   

  #Secret Service (passwords)
  services.gnome.gnome-keyring.enable = true;

  #Power Profiles Service
  services.power-profiles-daemon.enable = true;

  #PAM: Unlock the keyring when log in
  security.pam.services.login.enableGnomeKeyring = true;
  security.pam.services.greetd.enableGnomeKeyring = true;
  security.pam.services.sddm.enableGnomeKeyring = true;

  # Set your time zone.
  time.timeZone = "America/Costa_Rica";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "es_CR.UTF-8";
    LC_IDENTIFICATION = "es_CR.UTF-8";
    LC_MEASUREMENT = "es_CR.UTF-8";
    LC_MONETARY = "es_CR.UTF-8";
    LC_NAME = "es_CR.UTF-8";
    LC_NUMERIC = "es_CR.UTF-8";
    LC_PAPER = "es_CR.UTF-8";
    LC_TELEPHONE = "es_CR.UTF-8";
    LC_TIME = "es_CR.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "intl";
  };

  # Configure console keymap
  console.keyMap = "us-acentos";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.aryel = {
    isNormalUser = true;
    description = "aryel";
    extraGroups = [ "networkmanager" "wheel" "audio" "video" ];
    packages = with pkgs; [];
  };

  #Audio
  security.rtkit.enable = true;
  services.pipewire = {
   enable = true;
   alsa = {
     enable = true;
     support32Bit = true;
   };
   pulse.enable = true;
   jack.enable = true;
  };

  #Bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  #Zram, swap and oom
  zramSwap = {
    enable = true;
    memoryPercent = 50;
  };

  swapDevices = [
    { device = "/swapfile"; size = 4096; }
  ];

  systemd.oomd.enable = true;

  boot.kernel.sysctl = {
    "vm.swappiness" = 85;
    "vm.vfs_cache_pressure" = 100;
    "vm.overcommit_memory" = 1;
    "vm.overcommit_ratio" = 100;
    "vm.compact_memory" = 1;
    "vm.compaction_proactiveness" = 80;
  };


  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  #Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  #Terminal interface improvement
  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
      };
    };
  };


  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #Terminal
    kitty

    #Cursor
    #bibata-cursors
    adwaita-icon-theme
    
    #Utilities
    git
    wget
    fastfetch
    brightnessctl
    acpi

    #Keyring
    gnome-keyring
    libsecret
    
    #Useful
    brave
    power-profiles-daemon

    #Screenshot
    grim
    slurp
    wl-clipboard
    grimblast

    #File manager
    nautilus
  ];
  
 # environment.variables = {
 #   XCURSOR_THEME = "Adwaita";
 #   XCURSOR_SIZE = "24";
 # };

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-color-emoji
    noto-fonts-cjk-sans
    nerd-fonts.jetbrains-mono
  ];

  services.logind = {
    powerKey = "ignore";
  };
   

  #Polkit (for permissions)
  security.polkit.enable = true;

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
  system.stateVersion = "25.11"; # Did you read the comment?

}
