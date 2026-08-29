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
  ];
  #================================
  # MACBOOK AIR WIFI CONFIG
  #================================

  nixpkgs.config.allowUnfree = true;
  boot.initrd.kernelModules = [ "wl" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];
  boot.blacklistedKernelModules = [ "b43" "ssb" "brcmfmac" "brcmsmac" "bcma" ];
  nixpkgs.config.permittedInsecurePackages = [
    "broadcom-sta-6.30.223.271-59-7.0.12"
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

  # GNOME keyring: provee el Secret Service (org.freedesktop.secrets) que usa
  # git-credential-manager (GitHub). El keyring "login" se desbloquea en el
  # login con la contraseña del usuario via PAM (pam_gnome_keyring), así Git
  # no vuelve a pedir credenciales durante la sesión.
  services.gnome.gnome-keyring.enable = true;
  # dconf must stay enabled: HM's gtk module writes cursor/theme settings
  # through the dconf DBus service during activation
  programs.dconf.enable = true;

  services.power-profiles-daemon.enable = true;

  # Desbloqueo automático del keyring al iniciar sesión
  security.pam.services.login.enableGnomeKeyring = true;
  security.pam.services.greetd.enableGnomeKeyring = true;
  security.pam.services.swaylock.enableGnomeKeyring = true;
  security.pam.services.sddm.enableGnomeKeyring = false;

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

  # Español estilo macOS: @ con Alt+2 y tildes con Alt (Alt+E -> á)
  # Layout custom definido en ./es-mac.xkb
  services.xserver.xkb = {
    layout = "es-mac";
    extraLayouts.es-mac = {
      description = "Spanish (Mac-style, accents via Alt)";
      languages = [ "spa" ];
      symbolsFile = ./es-mac.xkb;
    };
  };

  console.keyMap = "es";

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
  # DISK MOUNTING — udisks2 + polkit
  #=============================================================================

  # udisks2 expone los discos por D-Bus: Nautilus y udiskie los detectan y
  # montan automáticamente al conectarlos (USB, discos duros externos, etc.).
  services.udisks2.enable = true;

  # Permitir al grupo "users" (aryel) montar/desmontar/desbloquear cualquier
  # disco sin pedir contraseña al usar Nautilus o udiskie.
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (action.id.startsWith("org.freedesktop.udisks2.") &&
          subject.isInGroup("users")) {
        return polkit.Result.YES;
      }
    });
  '';

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
  # UDEV — Nintendo Switch
  #=============================================================================

  services.udev.extraRules = ''
    # RCM / APX (payload injection - hekate, TegraRcmGUI, etc.)
    SUBSYSTEM=="usb", ATTRS{idVendor}=="0955", ATTRS{idProduct}=="7321", MODE="0666", GROUP="plugdev"
    # Nintendo Switch estándar (NXDT, GoldLeaf, etc.)
    SUBSYSTEM=="usb", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="3000", MODE="0666", GROUP="plugdev"
    # SysDVR (se presenta como dispositivo Android fastboot)
    SUBSYSTEM=="usb", ATTRS{idVendor}=="18d1", ATTRS{idProduct}=="4ee0", MODE="0666", GROUP="plugdev"
  '';

  users.groups.plugdev = {};

  #=============================================================================
  # USER
  #=============================================================================

  users.users.aryel = {
    isNormalUser = true;
    description = "aryel";
    extraGroups = [ "networkmanager" "wheel" "audio" "video" "plugdev" ];
    packages = with pkgs; [];
  };

  #=============================================================================
  # XDG DESKTOP PORTAL — Sway edition
  #=============================================================================

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

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
    brave
    git
    podman-compose
    kitty
    adwaita-icon-theme
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
  # TERMINAL PROMPT — Starship (flecha + estado git), igual que thinkbook
  #=============================================================================

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

  #=============================================================================
  # STATE VERSION
  #=============================================================================
  services.openssh = {
    enable = true;
  };

  system.stateVersion = "26.05";
}
