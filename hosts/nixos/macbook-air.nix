{ config, pkgs, lib, ... }:

{
  imports =
    [
      ./hardware-configuration-macbook-air.nix
    ];

  #=============================================================================
  # BOOT & KERNEL
  #=============================================================================

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_zen;

  #---------------
  # Kernel parameters — MacBook Air 2015
  #---------------
  boot.kernelParams = [
    "i915.enable_psr=1"        # Panel Self Refresh — battery
    "i915.enable_fbc=1"        # Framebuffer compression
    "i915.enable_dc=1"         # Deep display power states
    "pcie_aspm=force"          # Aggressive PCIe power saving
    "snd_hda_intelpower_save=4"  # Audio power saving
    "snd_hda_intelpower_save=1"
    "bcma.no_ucode=1"          # BCMA firmware workaround
    "b43=1"                    # b43 module blacklist (handled via broadcom-sta)
  ];
  #================================
  # MACBOOK AIR WIFI CONFIG
  #================================
   
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "broadcom-sta-6.30.223.271-59-6.18.45"
  ];

  #=============================================================================
  # FIRMWARE
  #=============================================================================

  hardware.enableRedistributableFirmware = true;

  #=============================================================================
  # NETWORKING
  #=============================================================================

  networking.hostName = "macbook-air";
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

  #=============================================================================
  # PODMAN — Replace Docker with Podman
  #=============================================================================

  virtualisation.podman = {
    enable = true;
  };

  #=============================================================================
  # GRAPHICS & 32-BIT
  #=============================================================================

  hardware.graphics.enable32Bit = true;

  #=============================================================================
  # KEYRING & SECRET SERVICE
  #=============================================================================

  # No GNOME keyring on Sway - use pass + simple keyring
  services.gnome.gnome-keyring.enable = false;
  programs.dconf.enable = false;

  services.power-profiles-daemon.enable = true;

  # Simple keyring alternative for passwords
  security.pam.services.login.enableGnomeKeyring = false;
  security.pam.services.greetd.enableGnomeKeyring = false;
  security.pam.services.sddm.enableGnomeKeyring = false;

  programs.git = {
    enable = true;
    config = {
      credential.helper = "cache";
    };
  };

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

  services.xserver.xkb = {
    layout = "us";
    variant = "intl";
  };

  console.keyMap = "us-acentos";

  #=============================================================================
  # AUDIO — PipeWire
  #=============================================================================

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
    jack.enable = false;
  };

  #=============================================================================
  # BLUETOOTH
  #=============================================================================

  hardware.bluetooth.enable = true;

  #=============================================================================
  # MEMORY — Zram, Swap, OOM
  #=============================================================================

  zramSwap = {
    enable = true;
    memoryPercent = 20;
  };

  swapDevices = [
    { device = "/swapfile"; size = 2048; }
  ];

  services.earlyoom = {
    enable = true;
    freeMemThreshold = 10;
    freeSwapThreshold = 15;
  };

  #=============================================================================
  # USER
  #=============================================================================

  users.users.aryel = {
    isNormalUser = true;
    description = "aryel";
    extraGroups = [ "networkmanager" "wheel" "audio" "video" ];
    packages = with pkgs; [];
  };

  #=============================================================================
  # XDG DESKTOP PORTAL — Sway edition
  #=============================================================================

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-wlr ];
    config.common.default = "sway";
  };

  #=============================================================================
  # SESSION VARIABLES — Sway
  #=============================================================================

  environment.sessionVariables = {
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
    XDG_CURRENT_DESKTOP = "sway";
    XDG_SESSION_DESKTOP = "sway";
    XDG_SESSION_TYPE = "wayland";
    XCURSOR_THEME = "Bibata-Modern-Ice";
    XCURSOR_SIZE = "24";
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    QT_LOGGING_RULES = "*.debug=false;qt.qpa.*=false";
    WLR_NO_HARDWARE_CURSORS = "1";
  };

  #=============================================================================
  # SYSTEM PACKAGES
  #=============================================================================

  environment.systemPackages = with pkgs; [
    kitty
    adwaita-icon-theme
    git
    wget
    fastfetch
    acpi
    unzip
    unrar
    p7zip
    pavucontrol
    swayimg
    mpv
    cmus
    vlc
    system-config-printer
    dosbox
    polkit_gnome
    gsettings-desktop-schemas
    # Lazyspotify replaced by podman-remote or direct spotify client
    # spotify kept as flatpak
    nodejs_22
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
  # POLKIT
  #=============================================================================

  security.polkit.enable = true;

  #=============================================================================
  # STATE VERSION
  #=============================================================================

  system.stateVersion = "26.05";
}
