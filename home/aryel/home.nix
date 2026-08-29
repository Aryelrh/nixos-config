#===============================================================================
# HOME MANAGER — Aryel's User Configuration
#===============================================================================

{ pkgs, inputs, ... }:

let
  nvimConfigPath = builtins.path {
    path = ../../modules/home/nvim;
    name = "nvim-config";
  };
in
{
  #=============================================================================
  # GENERAL
  #=============================================================================

  home.stateVersion = "26.05";
  programs.home-manager.enable = true;
  home.username = "aryel";
  home.homeDirectory = "/home/aryel";

  #=============================================================================
  # NEOVIM
  #=============================================================================

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
  };

  #=============================================================================
  # DIRENV
  #=============================================================================

  programs.direnv.enable = true;
  programs.direnv.enableBashIntegration = true;
  programs.direnv.nix-direnv.enable = true;

  #=============================================================================
  # ZED EDITOR
  #=============================================================================

  programs.zed-editor = {
    enable = true;
    enableMcpIntegration = true;
    userSettings = {
      auto_save = "on_focus_change";
      theme = "One Dark";
    };
    extensions = [
      "github-copilot"
      "claude-acp"
      "gemini"
      "qwen-code"
      "java"
      "dockerfile"
      "sql"
      "nix"
      "prisma"
      "docker-compose"
      "opencode"
      "ini"
      "pylsp"
      "xml"
      "min-theme"
      "codebook"
      "colored-zed-icons-theme"
    ];
    extraPackages = with pkgs; [
      nixd
    ];
  };

  #=============================================================================
  # KEYRING
  #=============================================================================

  services.gnome-keyring = {
    enable = true;
    components = [ "secrets" ];
  };

  programs.git = {
    enable = true;
    settings.credential = {
      helper = "${pkgs.git-credential-manager}/bin/git-credential-manager";
      credentialStore = "secretservice";
    };
  };

  #=============================================================================
  # DISK MOUNTING — automount
  #=============================================================================

  # udiskie: monta automáticamente los discos que se conecten. Requiere
  # services.udisks2.enable = true en el host (macbook-air).
  services.udiskie = {
    enable = true;
    automount = true;
    notify = true;
    tray = "never";
  };

  #=============================================================================
  # GVFS — trash y monitores de volumen (necesario para Nautilus)
  #=============================================================================

  # En Sway no hay gnome-session que arranque gvfs. Estas units de usuario
  # inician gvfsd al abrir la sesión gráfica: sin gvfsd, Nautilus no soporta la
  # papelera (trash://) ni detecta discos/MTP, y "Move to Trash" cae a borrado
  # permanente previa confirmación.
  systemd.user.services = {
    gvfs-daemon = {
      Unit = {
        Description = "Virtual filesystem service";
        PartOf = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = "${pkgs.gvfs}/libexec/gvfsd";
        Type = "dbus";
        BusName = "org.gtk.vfs.Daemon";
        Slice = "session.slice";
      };
      Install.WantedBy = [ "graphical-session.target" ];
    };

    gvfs-udisks2-volume-monitor = {
      Unit = {
        Description = "Virtual filesystem service - disk device monitor";
        PartOf = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = "${pkgs.gvfs}/libexec/gvfs-udisks2-volume-monitor";
        Type = "dbus";
        BusName = "org.gtk.vfs.UDisks2VolumeMonitor";
        Slice = "session.slice";
      };
      Install.WantedBy = [ "graphical-session.target" ];
    };

    gvfs-mtp-volume-monitor = {
      Unit = {
        Description = "Virtual filesystem service - Media Transfer Protocol monitor";
        PartOf = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = "${pkgs.gvfs}/libexec/gvfs-mtp-volume-monitor";
        Type = "dbus";
        BusName = "org.gtk.vfs.MTPVolumeMonitor";
        Slice = "session.slice";
      };
      Install.WantedBy = [ "graphical-session.target" ];
    };
  };

  #=============================================================================
  # USER PACKAGES
  #=============================================================================

  home.packages = [
    #------------------
    # Wayland
    #------------------
    pkgs.wlr-randr
    pkgs.dunst
    pkgs.grim
    pkgs.slurp
    pkgs.wl-clipboard
    pkgs.libnotify

    #------------------
    # Utilities
    #------------------
    pkgs.pavucontrol
    pkgs.lavat
    pkgs.swayimg
    pkgs.mpv
    pkgs.cmus
    pkgs.vlc
    pkgs.system-config-printer
    pkgs.dosbox
    pkgs.umu-launcher
    pkgs.git-credential-manager

    #------------------
    # Apps
    #------------------
    pkgs.vscode
    pkgs.spotify
    pkgs.github-desktop
    pkgs.maven
    pkgs.obsidian
    pkgs.bottom
    pkgs.jetbrains.clion
    pkgs.onlyoffice-desktopeditors
    pkgs.mongodb-compass
    pkgs.postman
    pkgs.dbeaver-bin
    pkgs.prismlauncher

    pkgs.nodejs_22

    #------------------
    # Wayland & GTK
    #------------------
    pkgs.polkit_gnome
    pkgs.gsettings-desktop-schemas
    pkgs.glib
    pkgs.nautilus
    pkgs.gvfs
  ];

  #=============================================================================
  # CURSOR
  #=============================================================================

  home.pointerCursor = {
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
    size = 24;
  };

  #=============================================================================
  # GTK THEME
  #=============================================================================

  gtk = {
    enable = true;

    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
  };

  # Nautilus como gestor de archivos por defecto
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "inode/directory" = "org.gnome.Nautilus.desktop";
    };
  };

  # Nautilus (libadwaita) en modo oscuro sin tocar el gtk.theme:
  # color-scheme solo afecta a apps libadwaita/GTK4, no a tus temas GTK3.
  dconf.settings = {
    "org/gnome/desktop/interface".color-scheme = "prefer-dark";
  };

  #=============================================================================
  # SESSION VARIABLES
  #=============================================================================

  home.sessionVariables = {
    MAVEN_HOME = "${pkgs.maven}";
    GTK_THEME = "Adwaita-dark";
    MESA_LOADER_DRIVER_OVERRIDE = "iris";
    MESA_NO_ERROR = "1";
  };

  #=============================================================================
  # SYMLINKS
  #=============================================================================

  home.file.".config/nvim".source = nvimConfigPath;

  # Directorio por defecto de capturas (grimblast copysave area)
  home.file."Pictures/Screenshots/.keep".text = "";

  #=============================================================================
  # IMPORTS
  #=============================================================================

  imports = [
    ../../modules/home/sway/default.nix
  ];

  #=============================================================================
  # ALIASES
  #=============================================================================

  programs.bash = {
    enable = true;

    shellAliases = {
      hm = "cd ~/nixos-config && sudo nixos-rebuild switch --impure --flake .#nixos";
      gc = "sudo nix-collect-garbage -d";
      spotui = "cd ~/LazySpotify/lazyspotify && nix develop --command make";
   };
  };
}
