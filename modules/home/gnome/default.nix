{ pkgs, ... }:

{
  # Enable GNOME Desktop
  services.gnome-keyring.enable = true;

  # GNOME Extensions
  home.packages = with pkgs; [
    (gnomeExtensions.appindicator)
    (gnomeExtensions.caffeine)
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
      num-workspaces = 9;
      raise-on-click = true;
    };

    # Window behavior
    "org/gnome/mutter" = {
    };

    # Hot corner disabled
    "org/gnome/desktop/wm/keybindings" = {
      close = ["<Super>q"];
      toggle-maximized = ["<Super>f"];
    };

    # Custom keybindings
    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/terminal/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/file-manager/"
      ];
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
        "appindicatorsupport@rgcjonas.gmail.com"
        "caffeine@patapon.info"
      ];

      favorite-apps = [
        "kitty.desktop"
        "org.gnome.Nautilus.desktop"
        "spotify.desktop"
        "vscode.desktop"
      ];
    };

    # Screenshot shortcut used by GNOME Shell
    "org/gnome/shell/keybindings" = {
      screenshot = [];
      show-screenshot-ui = ["<Shift><Super>s"];
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
    
    # Qt/Wayland - disable window decorations for flatpak apps
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    QT_LOGGING_RULES = "*.debug=false;qt.qpa.*=false";
    GTK_CSD = "1";
    
    # Hardware cursors cause issues on Wayland, especially with Intel iGPU
    WLR_NO_HARDWARE_CURSORS = "1";
  };

  # Theme symlinks
  xdg.configFile."kitty".source = ../components/WhiteBlackSchema/kitty;

  # Wallpaper symlink
  home.file."Pictures/Wallpapers/WhiteRed.png".source = ../components/WhiteBlackSchema/WhiteRed.png;
}
