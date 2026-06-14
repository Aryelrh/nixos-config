#===============================================================================
# MACBOOK — NixOS System Configuration
# Device: MacBook Pro 2019 (Intel, T2 chip)
#===============================================================================

{ config, pkgs, lib, ... }:

{
  imports =
    [
      ./hardware-configuration-macbook.nix
    ];

  #=============================================================================
  # BOOT & KERNEL
  #=============================================================================

  #---------------
  # Bootloader
  #---------------
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_zen;

  #------------------------------------------
  # Kernel parameters — MacBook T2 specific
  #------------------------------------------
  boot.kernelParams = [
    "apple_iommu=force"          # Required for T2 audio (apple-bce)
  ];

  #=============================================================================
  # NETWORKING
  #=============================================================================

  networking.hostName = "macbook";
  networking.networkmanager.enable = true;

  #=============================================================================
  # NIX
  #=============================================================================

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  #--------------------
  # Automatic cleanup
  #--------------------
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  nix.settings.auto-optimise-store = true;

  #=============================================================================
  # HOME MANAGER
  #=============================================================================

  home-manager.backupFileExtension = "bak";

  #=============================================================================
  # FLATPAK
  #=============================================================================

  services.flatpak.enable = true;
  systemd.services.flatpak-repo = {
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    '';
  };

  #=============================================================================
  # OVERLAYS
  #=============================================================================

  nixpkgs.overlays = [
    (final: prev: {
      lazyspotify = prev.callPackage ../../pkgs/lazyspotify.nix {};
    })
  ];

  #=============================================================================
  # APPLE T2 HARDWARE SUPPORT
  #=============================================================================

  hardware.apple-t2.enable = true;

  # Broadcom WiFi firmware (BCM4364 on T2 Macs)
  hardware.enableRedistributableFirmware = true;

  #=============================================================================
  # GRAPHICS & 32-BIT
  #=============================================================================

  hardware.graphics.enable32Bit = true;

  #=============================================================================
  # KEYRING & SECRET SERVICE
  #=============================================================================

  services.gnome.gnome-keyring.enable = true;
  programs.dconf.enable = true;

  security.pam.services.login.enableGnomeKeyring = true;
  security.pam.services.greetd.enableGnomeKeyring = true;
  security.pam.services.sddm.enableGnomeKeyring = true;

  #=============================================================================
  # TIME / LOCALE / KEYMAP
  #=============================================================================

  time.timeZone = "America/Costa_Rica";

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

  # MacBook keyboard is ISO (depending on region); US intl is fine
  services.xserver.xkb = {
    layout = "us";
    variant = "intl";
  };

  console.keyMap = "us-acentos";

  #=============================================================================
  # DOCKER
  #=============================================================================

  virtualisation.docker = {
    enable = true;
    daemon.settings = {
      bridge = "none";
      iptables = false;
      default-address-pools = [
        { base = "10.200.0.0/16"; size = 24; }
      ];
    };
  };

  #=============================================================================
  # GAMING
  #=============================================================================

  programs.xwayland.enable = true;
  programs.gamescope.enable = true;

  #=============================================================================
  # USER
  #=============================================================================

  users.users.aryel = {
    isNormalUser = true;
    description = "aryel";
    extraGroups = [ "networkmanager" "wheel" "audio" "video" "docker" ];
    packages = with pkgs; [];
  };

  #=============================================================================
  # AUDIO — PipeWire (via apple-bce on T2)
  #=============================================================================

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

  #=============================================================================
  # BLUETOOTH
  #=============================================================================

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  #=============================================================================
  # MEMORY — Zram, Swap, OOM
  #=============================================================================

  zramSwap = {
    enable = true;
    memoryPercent = 50;
  };

  swapDevices = [
    { device = "/swapfile"; size = 4096; }
  ];

  systemd.oomd.enable = true;

  #=============================================================================
  # SYSCTL
  #=============================================================================

  boot.kernel.sysctl = {
    "vm.swappiness" = 85;
    "vm.vfs_cache_pressure" = 100;
    "vm.overcommit_memory" = 1;
    "vm.overcommit_ratio" = 100;
    "vm.compact_memory" = 1;
    "vm.compaction_proactiveness" = 80;
  };

  #=============================================================================
  # UNFREE PACKAGES
  #=============================================================================

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "electron-38.8.4"
  ];

  #=============================================================================
  # SEATD
  #=============================================================================

  services.seatd.enable = true;

  #=============================================================================
  # XDG DESKTOP PORTAL
  #=============================================================================

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
    config.common.default = "gnome";
  };

  #=============================================================================
  # GNOME DESKTOP
  #=============================================================================

  services.xserver.enable = true;
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  services.gnome.core-apps.enable = false;
  services.gnome.core-developer-tools.enable = false;
  services.gnome.games.enable = false;

  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    gnome-user-docs
  ];

  #=============================================================================
  # OLLAMA — Local AI
  #=============================================================================

  services.ollama.enable = true;

  #=============================================================================
  # ZED — Nix-ld
  #=============================================================================

  programs.nix-ld.enable = true;

  #=============================================================================
  # SYSTEM PACKAGES
  #=============================================================================

  environment.systemPackages = with pkgs; [
    kitty
    adwaita-icon-theme
    git
    wget
    fastfetch
    unzip
    unrar
    p7zip
    lazyspotify
    gnome-keyring
    libsecret
    brave
    ntfs3g
    exfat
    nautilus
    gsettings-desktop-schemas
    gtk3
  ];

  #=============================================================================
  # SESSION VARIABLES
  #=============================================================================

  environment.sessionVariables = {
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
  };

  #=============================================================================
  # FONTS
  #=============================================================================

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-color-emoji
    noto-fonts-cjk-sans
    nerd-fonts.jetbrains-mono
  ];

  #=============================================================================
  # LOGIND
  #=============================================================================

  services.logind = {
    settings = {
      Login = {
        HandlePowerKey = "ignore";
      };
    };
  };

  #=============================================================================
  # PRINTING
  #=============================================================================

  services.printing.enable = true;

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  #=============================================================================
  # EXTERNAL DISKS
  #=============================================================================

  services.gvfs.enable = true;
  services.udisks2.enable = true;
  services.devmon.enable = true;

  #=============================================================================
  # POLKIT
  #=============================================================================

  security.polkit.enable = true;

  #=============================================================================
  # STATE VERSION
  #=============================================================================

  system.stateVersion = "25.11";
}
