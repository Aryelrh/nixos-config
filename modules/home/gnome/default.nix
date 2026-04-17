{ pkgs, ... }:

{
  # Enable GNOME Desktop
  services.gnome-keyring.enable = true;

  # GNOME Extensions
  home.packages = with pkgs.gnomeExtensions; [
    dash-to-dock
    appindicator
  ];

  # GNOME Settings
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "Adwaita-dark";
      icon-theme = "Papirus-Dark";
      cursor-theme = "Adwaita";
      cursor-size = 24;
      font-name = "Noto Sans 11";
      monospace-font-name = "JetBrains Mono 11";
      font-antialiasing = "rgba";
      font-hinting = "full";
    };

    "org/gnome/desktop/wm/preferences" = {
      titlebar-font = "Noto Sans Bold 11";
      action-middle-click-titlebar = "minimize";
      action-right-click-titlebar = "menu";
      focus-mode = "sloppy";
      focus-new-windows = "smart";
      mouse-button-modifier = "<Super>";
      num-workspaces = 9;
    };

    # Window behavior
    "org/gnome/mutter" = {
      edge-tiling = true;
      dynamic-workspaces = false;
      workspaces-only-on-primary = false;
      attach-modal-dialogs = true;
    };

    # Hot corner disabled
    "org/gnome/desktop/wm/keybindings" = {
      switch-to-workspace-1 = ["<Super>1"];
      switch-to-workspace-2 = ["<Super>2"];
      switch-to-workspace-3 = ["<Super>3"];
      switch-to-workspace-4 = ["<Super>4"];
      switch-to-workspace-5 = ["<Super>5"];
      switch-to-workspace-6 = ["<Super>6"];
      switch-to-workspace-7 = ["<Super>7"];
      switch-to-workspace-8 = ["<Super>8"];
      switch-to-workspace-9 = ["<Super>9"];

      move-to-workspace-1 = ["<Shift><Super>1"];
      move-to-workspace-2 = ["<Shift><Super>2"];
      move-to-workspace-3 = ["<Shift><Super>3"];
      move-to-workspace-4 = ["<Shift><Super>4"];
      move-to-workspace-5 = ["<Shift><Super>5"];
      move-to-workspace-6 = ["<Shift><Super>6"];
      move-to-workspace-7 = ["<Shift><Super>7"];
      move-to-workspace-8 = ["<Shift><Super>8"];
      move-to-workspace-9 = ["<Shift><Super>9"];

      close = ["<Super>q"];
      maximize = ["<Super>f"];
      unmaximize = [];
      toggle-maximized = [];
      minimize = [];
      show-application-menu = [];
      toggle-fullscreen = ["<Super><Shift>f"];
    };

    # Custom keybindings
    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/terminal/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/file-manager/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/app-launcher/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/screenshot/"
      ];

      screenshot = ["<Shift><Super>s"];
      screenshot-clip = [];
      window-screenshot = [];
      area-screenshot = [];
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/terminal" = {
      binding = "<Super>t";
      command = "kitty";
      name = "Terminal";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/file-manager" = {
      binding = "<Super>e";
      command = "nautilus";
      name = "File Manager";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/app-launcher" = {
      binding = "<Super>d";
      command = "fuzzel";
      name = "App Launcher";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/screenshot" = {
      binding = "<Shift><Super>s";
      command = "grim -g \"$(slurp)\" - | wl-copy";
      name = "Screenshot to Clipboard";
    };

    # Power button handling
    "org/gnome/settings-daemon/plugins/power" = {
      power-button-action = "nothing";
      sleep-inactive-ac-timeout = 0;
      sleep-inactive-battery-timeout = 600;
      sleep-inactive-battery-type = "suspend";
    };

    # Dock settings
    "org/gnome/shell" = {
      disabled-extensions = [];
      enabled-extensions = [
        "dash-to-dock@micxjo.github.com"
        "appindicatorsupport@gnome-shell-extensions.gcampax.github.com"
      ];

      favorite-apps = [
        "kitty.desktop"
        "org.gnome.Nautilus.desktop"
        "spotify.desktop"
        "vscode.desktop"
        "firefox.desktop"
      ];
    };

    # Dash to Dock settings
    "org/gnome/shell/extensions/dash-to-dock" = {
      dock-position = "BOTTOM";
      dock-fixed = true;
      autohide = false;
      autohide-pressure = false;
      dash-max-icon-size = 64;
      icon-size-fixed = false;
      show-apps-at-top = false;
      show-mounts-only-mounted = true;
      show-trash = true;
      multi-monitor = true;
      transparency-mode = "FIXED";
      background-opacity = 0.8;
    };

    # Activities overview settings
    "org/gnome/shell/app-switcher" = {
      current-workspace-only = false;
    };

    # Extensions
    "org/gnome/shell/extensions/native-window-placement" = {
      center-thumbnails = false;
    };
  };

  # Session variables for GNOME
  home.sessionVariables = {
    XDG_CURRENT_DESKTOP = "GNOME";
    XDG_SESSION_DESKTOP = "GNOME";
    XDG_SESSION_TYPE = "wayland";
    
    # Intel Iris Xe GPU optimization
    MESA_LOADER_DRIVER_OVERRIDE = "iris";
    MESA_NO_ERROR = "1";
    
    # Cursor settings
    XCURSOR_THEME = "Adwaita";
    XCURSOR_SIZE = "24";
    
    # Qt/Wayland
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    QT_LOGGING_RULES = "*.debug=false;qt.qpa.*=false";
    
    # Hardware cursors cause issues on Wayland, especially with Intel iGPU
    WLR_NO_HARDWARE_CURSORS = "1";
  };

  # Theme symlinks
  xdg.configFile."kitty".source = ../components/WhiteBlackSchema/kitty;
  xdg.configFile."fuzzel".source = ../components/WhiteBlackSchema/fuzzel;

  # Wallpaper symlink
  home.file."Pictures/Wallpapers/WhiteRed.png".source = ../components/WhiteBlackSchema/WhiteRed.png;
}
