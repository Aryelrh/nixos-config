#===============================================================================
# THINKBOOK — NixOS System Configuration
# Device: Lenovo ThinkBook (actual laptop)
#===============================================================================

{ config, pkgs, lib, inputs, ... }:

{
  imports =
    [
      ./hardware-configuration-thinkbook.nix
    ];

  #=============================================================================
  # BOOT & KERNEL
  #=============================================================================

  #---------------
  # Bootloader
  #---------------
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  #boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-bore-x86_64-v3;

  #-------------------------------------------------------
  # Binary cache del kernel CachyOS (lantian/attic)
  # IMPORTANTE: esto debe activarse en un rebuild PREVIO a
  # cambiar boot.kernelPackages, si no, compila desde fuente.
  #-------------------------------------------------------
  nix.settings.substituters = [ "https://attic.xuyh0120.win/lantian" ];
  nix.settings.trusted-public-keys = [ "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc=" ];

  #-------------------------
  # Kernel parameters
  #-------------------------
  boot.blacklistedKernelModules = [ "pcspkr" ];

  boot.kernelParams = [
    "i915.enable_psr=1"        # Panel Self Refresh — battery
    "i915.enable_fbc=1"        # Framebuffer compression
    "i915.enable_dc=1"         # Deep display power states
    "nvme.noacpi=1"            # NVMe ACPI conflict workaround
    "pcie_aspm=force"          # Aggressive PCIe power saving
    "nowatchdog"
    "split_lock_detect=off"
    "transparent_hugepage=madvise"
  ];

  #=============================================================================
  # NETWORKING
  #=============================================================================

  networking.hostName = "nixos";
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
    inputs.nix-cachyos-kernel.overlays.pinned
  ];

  #-------------------------------------------
  # Discord RPC — Flatpak rich presence
  #-------------------------------------------
  system.activationScripts.flatpak-discord-rpc = ''
    ${pkgs.flatpak}/bin/flatpak override --filesystem=xdg-run/discord-ipc-* || true
    ${pkgs.flatpak}/bin/flatpak override --filesystem=xdg-run/app/com.discordapp.Discord:create || true
  '';

  #=============================================================================
  # GRAPHICS & 32-BIT
  #=============================================================================

  hardware.graphics.enable32Bit = true;

  #=============================================================================
  # KEYRING & SECRET SERVICE
  #=============================================================================

  services.gnome.gnome-keyring.enable = true;
  programs.dconf.enable = true;
  services.power-profiles-daemon.enable = true;

  security.pam.services.login.enableGnomeKeyring = true;
  security.pam.services.lightdm.enableGnomeKeyring = true;

  programs.git = {
    enable = true;
    config = {
      credential.helper = "/run/current-system/sw/bin/git-credential-libsecret";
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
  hardware.steam-hardware.enable = true;

  #=============================================================================
  # UDEV — Nintendo Switch
  #=============================================================================

  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTR{idVendor}=="0955", ATTR{idProduct}=="7321", MODE="0666", GROUP="plugdev"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="3000", MODE="0666", GROUP="plugdev"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="18d1", ATTRS{idProduct}=="4ee0", MODE="0666"
  '';

  users.groups.plugdev = {};

  #=============================================================================
  # USER
  #=============================================================================

  users.users.aryel = {
    isNormalUser = true;
    description = "aryel";
    extraGroups = [ "networkmanager" "wheel" "audio" "video" "docker" "plugdev" ];
    packages = with pkgs; [];
  };

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
   jack.enable = true;
   extraConfig.pipewire."99-silent-bell" = {
     "context.properties" = {
       "module.x11.bell" = false;
     };
   };
  };

  #=============================================================================
  # BLUETOOTH
  #=============================================================================

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  #=============================================================================
  # MEMORY — Zram, Swap, OOM
  #=============================================================================

  # zramSwap = {
  #   enable = true;
  #   memoryPercent = 25;
  # };

  swapDevices = [{
    device = "/swapfile";
    size = 16384; # 16 GB
  }];

  services.earlyoom = {
    enable = true;
    freeMemThreshold = 5;
    freeSwapThreshold = 10;
  };

  #=============================================================================
  # Terminal interface improvement
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

  # XFCE keyboard — US International (AltGr para ñ y tildes)
  services.xserver.displayManager.sessionCommands = ''
    setxkbmap us intl
    xset b off
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
  # STEAM
  #=============================================================================

  programs.steam = {
    enable = true;

    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };

  #=============================================================================
  # SYSTEM PACKAGES
  #=============================================================================

  environment.systemPackages = with pkgs; [
    kitty
    adwaita-icon-theme
    gitFull
    wget
    fastfetch
    acpi
    unzip
    unrar
    p7zip
    lazyspotify
    gnome-keyring
    libsecret
    brave
    power-profiles-daemon
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

  services.printing = {
    enable = true;
    drivers = [ pkgs.epson-escpr2 ];
  };

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
