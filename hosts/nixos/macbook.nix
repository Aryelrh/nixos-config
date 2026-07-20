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
      dynamic-workspaces = prev.callPackage ../../pkgs/dynamic-workspaces.nix {};
      b00merang-windows-7 = prev.callPackage ../../pkgs/b00merang-windows-7/default.nix {};
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
  security.pam.services.lightdm.enableGnomeKeyring = true;

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
    memoryPercent = 25;
  };

  swapDevices = [
    { device = "/swapfile"; size = 4096; }
  ];

  services.earlyoom = {
    enable = true;
    freeMemThreshold = 5;
    freeSwapThreshold = 10;
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
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common.default = "xfce";
  };

  #=============================================================================
  # XFCE DESKTOP
  #=============================================================================

  services.xserver.enable = true;
  services.xserver.desktopManager.xfce.enable = true;
  services.xserver.desktopManager.xfce.enableXfwm = true;
  services.xserver.desktopManager.xfce.enableScreensaver = true;
  services.xserver.desktopManager.xfce.noDesktop = false;
  services.xserver.displayManager.lightdm.enable = true;

  # LightDM greeter
  services.xserver.displayManager.lightdm.greeters.gtk = {
    enable = true;
    theme = {
      name = "Windows-7";
      package = pkgs.b00merang-windows-7;
    };
    iconTheme = {
      name = "Windows-10";
      package = pkgs.windows10-icons;
    };
    cursorTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
      size = 24;
    };
    indicators = [
      "~host"
      "~spacer"
      "~clock"
      "~spacer"
      "~language"
      "~session"
      "~power"
    ];
    extraConfig = ''
      font-name=JetBrains Mono 11
    '';
  };

  # XFCE compose key (AltGr)
  services.xserver.desktopManager.xfce.extraSessionCommands = ''
    setxkbmap -option compose:ralt
  '';

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
    thunar
    thunar-volman
    thunar-archive-plugin
    gvfs
    gsettings-desktop-schemas
    gtk3
    xfce4-whiskermenu-plugin
    xfce4-pulseaudio-plugin
    xfce4-notifyd
    xfce4-taskmanager
    xfce4-screenshooter
    xfce4-panel-profiles
    xfce4-clipman-plugin
    xfce4-netload-plugin
    xfce4-cpugraph-plugin
    xfce4-power-manager
    ristretto
    mousepad
    xfce4-terminal
    lightdm-gtk-greeter
    wmctrl
    xdotool
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
