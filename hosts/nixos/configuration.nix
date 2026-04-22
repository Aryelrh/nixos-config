# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_zen;

  boot.kernelParams = [
    "i915.enable_psr=1"        # Panel Self Refresh — big battery win on Intel iGPU
    "i915.enable_fbc=1"        # Framebuffer compression
    "i915.enable_dc=1"         # Deep power states for display engine (try 2, fallback to 1 if issues)
    "nvme.noacpi=1"            # If you have NVMe — prevents ACPI conflicts
    "pcie_aspm=force"          # Aggressive PCIe power saving
  ];

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

  #Flatpak, for Sober
  services.flatpak.enable = true;
  systemd.services.flatpak-repo = {
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    '';
  };

  #Lazy Spotify flake consume
  nixpkgs.overlays = [
    (final: prev: {
      lazyspotify = prev.callPackage ../../pkgs/lazyspotify.nix {};
    })
  ];


  # Discord Rich Presence for Flatpak apps (Nuclear, etc.)
  system.activationScripts.flatpak-discord-rpc = ''
    ${pkgs.flatpak}/bin/flatpak override --filesystem=xdg-run/discord-ipc-* || true
    ${pkgs.flatpak}/bin/flatpak override --filesystem=xdg-run/app/com.discordapp.Discord:create || true
  '';

  #Secret Service (passwords)
  services.gnome.gnome-keyring.enable = true;

  #Dconf database (required for GNOME apps to store settings)
  programs.dconf.enable = true;
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
  
  #Docker activation
  virtualisation.docker = {
    enable = true;
    daemon.settings = {
      bridge = "none"; #Docker doesnt create docker0 auto
      iptables = false;
      default-address-pools = [
        { base = "10.200.0.0/16"; size = 24; } #Docker uses an ip pool that has no collision with other important ip's
      ];
    };
  };

  programs.xwayland.enable = true;
  programs.gamescope.enable = true;
  hardware.steam-hardware.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.aryel = {
    isNormalUser = true;
    description = "aryel";
    extraGroups = [ "networkmanager" "wheel" "audio" "video" "docker" ];
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
  nixpkgs.config.permittedInsecurePackages = [
    "electron-38.8.4"
  ];

  #Seatd
  services.seatd.enable = true;
  
  #Portal
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-gnome ];
    configPackages = [ pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-gnome ];
    config = {
      common.default = "*";
      "org.freedesktop.impl.portal.FileChooser".default = "gtk";
    };
  };

  #GNOME Desktop Environment
  services.xserver.enable = true;
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  services.gnome.core-apps.enable = false;
  services.gnome.core-developer-tools.enable = false;
  services.gnome.games.enable = false;

  # Ollama to run local IA models
  services.ollama.enable = true;

  # Exclude some GNOME packages
  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    gnome-user-docs
  ];

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
    unzip
    unrar
    p7zip
    lazyspotify

    #Keyring
    gnome-keyring
    libsecret
    
    #Useful
    brave
    power-profiles-daemon
    ntfs3g

    #Screenshot
    grim
    slurp
    wl-clipboard
    grimblast

    #File manager
    nautilus
    
    #GSettings schemas (required by MongoDB Compass and GNOME apps)
    gsettings-desktop-schemas
    glib
  ];
  
  environment.sessionVariables = {
    #Electron apps should use XWayland (more stable in Wayland)
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
  };

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-color-emoji
    noto-fonts-cjk-sans
    nerd-fonts.jetbrains-mono
  ];

  services.logind = {
    settings = {
      Login = {
        HandlePowerKey = "ignore";
      };
    };
  };

  services.printing = {
    enable = true;
    drivers = [ pkgs.epson-escpr2 ];
  };

  # Para impresoras en red (WiFi/Ethernet):
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
  
  #External disk automount
  services.udisks2.enable = true;   

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
