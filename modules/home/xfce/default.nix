{ pkgs, lib, config, ... }:

let
  macos9-theme = pkgs.stdenv.mkDerivation {
    pname = "macos9-theme";
    version = "unstable-2026-07-21";

    platinum9 = pkgs.fetchFromGitHub {
      owner = "grassmunk";
      repo = "Platinum9";
      rev = "d3d2080c1a2d5772714d089d1dc1daeeb41db008";
      sha256 = "sha256-rKM2/Hk1Z/HszSAO0Yf/Zh3d+QGTRJrAE/Mo90Qxgvw=";
    };

    src = pkgs.fetchFromGitHub {
      owner = "B00merang-Project";
      repo = "Mac-OS-9";
      rev = "ca8a5d2a3fb1976cf904133574a3d0022ac2cf71";
      sha256 = "sha256-gMyLP+7rZdhlCZVVHjzvWvQzvWSLfNZWCvgFUWuMeyw=";
    };

    dontBuild = true;
    installPhase = ''
      # GTK theme de B00merang (gtk-2.0 + gtk-3.0 + gtk-4.0) — widgets/panel
      mkdir -p $out/share/themes/Mac-OS-9
      cp -r $src/* $out/share/themes/Mac-OS-9/

      # xfwm4 de Platinum9 — bordes de ventana
      mkdir -p $out/share/themes/PlatiPlus
      cp -r $platinum9/PlatiPlus/* $out/share/themes/PlatiPlus/

      mkdir -p $out/share/themes/PlatiPlus26
      cp -r $platinum9/PlatiPlus26/* $out/share/themes/PlatiPlus26/

      # Fonts de Platinum9
      mkdir -p $out/share/fonts/truetype
      cp $platinum9/Charcoal.ttf $out/share/fonts/truetype/
      cp $platinum9/MONACO.TTF $out/share/fonts/truetype/

      # Wallpaper
      mkdir -p $out/share/backgrounds
      cp $platinum9/OS9-wallpaper/*.png $out/share/backgrounds/ 2>/dev/null || true
    '';
  };
in

{
  home.packages = with pkgs; [
    # XFCE goodies
    thunar
    thunar-archive-plugin
    thunar-volman
    xfce4-whiskermenu-plugin
    xfce4-pulseaudio-plugin
    xfce4-notifyd
    xfce4-taskmanager
    xfce4-screenshooter
    xfce4-panel-profiles
    ristretto
    xfce4-clipman-plugin
    xfce4-netload-plugin
    xfce4-cpugraph-plugin
    pavucontrol
    mousepad
    xfce4-session

    # Icons
    papirus-icon-theme

    # Tema GTK / xfwm4 (widgets + bordes de ventana), variante oscura
    arc-theme

    macos9-theme
  ];

  #=============================================================================
  # XFCONF — TODO lo que sea un canal "vivo" de xfconfd vive aquí, no en
  # xdg.configFile.
  #
  # Por qué: xfconfd carga sus canales en memoria al iniciar sesión y los
  # vuelve a escribir sobre esos mismos archivos AL CERRAR SESIÓN — sin
  # importar si tú tocaste algo por GUI o no. Cualquier canal declarado vía
  # xdg.configFile (symlink al Nix store) se rompe en el primer logout,
  # porque xfconfd no puede escribir sobre un symlink inmutable y lo
  # reemplaza por un archivo real con SU estado, no el tuyo.
  #
  # `xfconf.settings` en cambio corre `xfconf-query` en cada activación de
  # Home Manager, empujando cada valor al daemon vivo por D-Bus. Así se
  # "auto-repara" en cada rebuild, sin importar qué haya pasado en medio.
  #=============================================================================

  xfconf.enable = true;
  xfconf.settings = {

    #-----------------------------------------------------------------------
    # xsettings — tema GTK, iconos, fuentes, doble-click, antialiasing
    #-----------------------------------------------------------------------
    xsettings = {
      "Net/ThemeName" = "Mac-OS-9";
      "Net/IconThemeName" = "Papirus-Dark";
      "Net/DoubleClickTime" = 250;
      "Net/DoubleClickDistance" = 5;
      "Net/CursorBlink" = true;
      "Net/CursorBlinkTime" = 1200;
      "Net/EnableEventSounds" = false;
      "Net/EnableInputFeedbackSounds" = false;

      "Xft/DPI" = -1;
      "Xft/Antialias" = 1;
      "Xft/Hinting" = 1;
      "Xft/HintStyle" = "hintslight";
      "Xft/RGBA" = "rgb";

      "Gtk/DecorationLayout" = "menu:minimize,maximize,close";
      "Gtk/FontName" = "JetBrains Mono 11";
      "Gtk/ToolbarStyle" = "icons";
    };

    #-----------------------------------------------------------------------
    # xfwm4 — tema de bordes/ventana, compositor, workspaces
    #-----------------------------------------------------------------------
    xfwm4 = {
      "general/theme" = "PlatiPlus26";
      "general/activate_action" = "bring";
      "general/borderless_maximize" = true;
      "general/button_layout" = "O|SHMC";
      "general/click_raise" = true;
      "general/compositor_active" = true;
      "general/compositor_refresh_rate" = "auto";
      "general/compositor_sync" = "fifo";
      "general/double_click_action" = "maximize";
      "general/double_click_distance" = 8;
      "general/easy_click" = "Super";
      "general/focus_delay" = 250;
      "general/focus_new" = true;
      "general/gap_height" = 5;
      "general/gap_width" = 5;
      "general/inactive_opacity" = 100;
      "general/mousewheel_rollup" = true;
      "general/placement_mode" = "center";
      "general/placement_ratio" = 100;
      "general/prevent_focus_stealing" = true;
      "general/raise_on_focus" = true;
      "general/scroll_workspaces" = true;
      "general/shadow_delta_height" = 2;
      "general/shadow_delta_width" = 2;
      "general/shadow_delta_x" = 0;
      "general/shadow_delta_y" = -2;
      "general/shadow_opacity" = 50;
      "general/show_app_icon" = true;
      "general/show_frame_shadow" = true;
      "general/snap_to_border" = true;
      "general/snap_to_windows" = true;
      "general/snap_width" = 10;
      "general/title_alignment" = "center";
      "general/title_font" = "JetBrains Mono 11";
      "general/use_compositing" = true;
      "general/vblank_mode" = "auto";
      "general/workspace_count" = 6;
      "general/workspace_names" = [ "1" "2" "3" "4" "5" "6" ];
      "general/wrap_cycle" = true;
      "general/wrap_workspaces" = false;
      "general/workspace_cycle" = true;
    };

    #-----------------------------------------------------------------------
    # xfce4-keyboard-shortcuts — TODOS tus atajos, incluido el screenshot
    # que se rompió y el intento de Super_L (ver nota abajo)
    #-----------------------------------------------------------------------
    xfce4-keyboard-shortcuts = {
      "commands/default/<Alt>F1" = "xfce4-popup-whiskermenu";
      "commands/default/<Alt>F2" = "xfce4-appfinder --collapsed";
      "commands/default/<Alt>F3" = "xfce4-appfinder";
      "commands/default/<Primary><Alt>Delete" = "xflock4";
      "commands/default/<Primary><Alt>l" = "xflock4";
      "commands/default/<Primary><Alt>t" = "exo-open --launch TerminalEmulator";
      "commands/default/<Super>e" = "thunar";
      "commands/default/<Super>t" = "kitty";
      "commands/default/XF86Display" = "xfce4-display-settings --minimal";
      "commands/default/Print" = "xfce4-screenshooter";
      "commands/default/<Shift>Print" = "xfce4-screenshooter --region";

      "commands/custom/<Super>s" = "xfce4-screenshooter";
      "commands/custom/<Super><Shift>s" = "xfce4-screenshooter --region";

      # Fix real del Super para whiskermenu: NO existe una propiedad
      # "shortcut" en el plugin del panel (lo verificamos con
      # xfconf-query -c xfce4-panel -p /plugins/plugin-6/shortcut → "no
      # existe"). El mecanismo correcto y soportado es bindear la keysym
      # sola como shortcut de teclado normal, igual que cualquier otro atajo.
      # Se enlazan L y R para que funcione sin importar cuál Super uses.
      #
      # OJO — limitación conocida de XFCE: al bindear Super_L/Super_R solos,
      # a veces interfiere con OTROS atajos que usan <Super>+tecla (tienes
      # <Super>d, <Super>e, <Super>f, <Super>q, <Super>t, <Super>s abajo).
      # Si notas que esos dejan de disparar bien, es este binding — se
      # soluciona quitando Super_R (dejando solo Super_L) o quitándolo del
      # todo y usando Alt+F1 (ya bindeado abajo) como alternativa.
      "commands/custom/Super_L" = "xfce4-popup-whiskermenu";
      "commands/custom/Super_R" = "xfce4-popup-whiskermenu";

      "xfwm4/default/<Alt>F4" = "close_window_key";
      "xfwm4/default/<Alt>F7" = "move_window_key";
      "xfwm4/default/<Alt>F8" = "resize_window_key";
      "xfwm4/default/<Alt>F9" = "hide_window_key";
      "xfwm4/default/<Alt>F10" = "maximize_window_key";
      "xfwm4/default/<Alt>F11" = "fullscreen_key";
      "xfwm4/default/<Alt>F12" = "above_key";
      "xfwm4/default/<Alt>Tab" = "cycle_windows_key";
      "xfwm4/default/<Alt><Shift>Tab" = "cycle_reverse_windows_key";
      "xfwm4/default/<Control><Alt>Down" = "down_workspace_key";
      "xfwm4/default/<Control><Alt>Left" = "left_workspace_key";
      "xfwm4/default/<Control><Alt>Right" = "right_workspace_key";
      "xfwm4/default/<Control><Alt>Up" = "up_workspace_key";
      "xfwm4/default/<Control><Alt>d" = "show_desktop_key";
      "xfwm4/default/<Super>d" = "show_desktop_key";
      "xfwm4/default/<Super>f" = "maximize_window_key";
      "xfwm4/default/<Super>q" = "close_window_key";
      "xfwm4/default/<Primary><Alt>End" = "move_to_next_workspace_key";
      "xfwm4/default/<Primary><Alt>Home" = "move_to_prev_workspace_key";
    };

    #-----------------------------------------------------------------------
    # xfce4-desktop — wallpaper por monitor
    #-----------------------------------------------------------------------
    xfce4-desktop = {
      "backdrop/screen0/monitoreDP-1/workspace0/color-style" = 0;
      "backdrop/screen0/monitoreDP-1/workspace0/image-style" = 5;
      "backdrop/screen0/monitoreDP-1/workspace0/last-image" =
        "${config.home.homeDirectory}/Pictures/Wallpapers/WhiteRed.png";

      "backdrop/screen0/monitorHDMI-A-1/workspace0/color-style" = 0;
      "backdrop/screen0/monitorHDMI-A-1/workspace0/image-style" = 5;
      "backdrop/screen0/monitorHDMI-A-1/workspace0/last-image" =
        "${config.home.homeDirectory}/Pictures/Wallpapers/WhiteRed.png";
    };

    #-----------------------------------------------------------------------
    # xfce4-panel — NO declaramos nada aquí. La propiedad "shortcut" que
    # intentamos antes no existe en whiskermenu (confirmado con
    # xfconf-query); el Super_L ahora se resuelve en xfce4-keyboard-shortcuts
    # arriba. Si en el futuro quieres migrar el layout real del panel (los
    # plugins reales, no la plantilla muerta de xfce4/panel/default.xml),
    # expórtalo primero con: xfconf-query -c xfce4-panel -lv
    #-----------------------------------------------------------------------
  };

  #=============================================================================
  # Archivos que NO son canales de xfconf — no hay daemon de por medio, así
  # que xdg.configFile es 100% seguro aquí (nada los va a pisar en logout).
  #=============================================================================
  xdg.configFile = {
    "xfce4/terminal/terminalrc".text = ''
      [Configuration]
      FontName=JetBrains Mono 11
      MiscAlwaysShowTabs=FALSE
      MiscBell=FALSE
      MenubarVisibleDefault=FALSE
      ScrollingUnlimited=TRUE
    '';

    "Thunar/uca.xml" = {
      force = true;
      text = ''
        <?xml version="1.0" encoding="UTF-8"?>
        <actions>
          <action>
            <icon>utilities-terminal</icon>
            <name>Open Terminal Here</name>
            <command>kitty --working-directory %f</command>
            <patterns>*</patterns>
            <startup-notify/>
            <directories/>
          </action>
        </actions>
      '';
    };
  };

  # GTK theme configuration
  gtk = {
    enable = true;

    theme = {
      name = "Mac-OS-9";
      package = macos9-theme;
    };

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

    font = {
      name = "JetBrains Mono";
      size = 11;
    };

    gtk3.extraConfig."gtk-application-prefer-dark-theme" = true;
    gtk4.extraConfig."gtk-application-prefer-dark-theme" = true;
  };

  # Session variables
  home.sessionVariables = {
    XDG_CURRENT_DESKTOP = "XFCE";
    XDG_SESSION_DESKTOP = "XFCE";
    XDG_SESSION_TYPE = "x11";
    QT_QPA_PLATFORM = "xcb";
    QT_STYLE_OVERRIDE = "gtk2";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
  };

  # Kitty config from existing theme
  xdg.configFile."kitty".source = ../components/WhiteBlackSchema/kitty;
}
