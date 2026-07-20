{ pkgs, lib, config, ... }:

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

    # Windows 7 theme
    pkgs.b00merang-windows-7

    # Windows 10 icons (closest to Win7)
    windows10-icons
  ];

  # XFCE configuration via xfconf XML files
  xdg.configFile = {
    "xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml".text = ''
      <?xml version="1.0" encoding="UTF-8"?>
      <channel name="xfwm4" version="1.0">
        <property name="general" type="empty">
          <property name="activate_action" type="string" value="bring"/>
          <property name="borderless_maximize" type="bool" value="true"/>
          <property name="box_move" type="bool" value="false"/>
          <property name="box_resize" type="bool" value="false"/>
          <property name="button_layout" type="string" value="O|SHMC"/>
          <property name="button_offset" type="int" value="0"/>
          <property name="click_raise" type="bool" value="true"/>
          <property name="compositor_active" type="bool" value="true"/>
          <property name="compositor_refresh_rate" type="string" value="auto"/>
          <property name="compositor_sync" type="string" value="fifo"/>
          <property name="cycle_apps_only" type="bool" value="false"/>
          <property name="cycle_draw_frame" type="bool" value="true"/>
          <property name="cycle_hidden" type="bool" value="true"/>
          <property name="cycle_minimum" type="bool" value="true"/>
          <property name="cycle_preview" type="bool" value="true"/>
          <property name="cycle_tabwin_mode" type="int" value="0"/>
          <property name="cycle_workspaces" type="bool" value="false"/>
          <property name="double_click_action" type="string" value="maximize"/>
          <property name="double_click_distance" type="int" value="8"/>
          <property name="double_click_time" type="int" value="250"/>
          <property name="easy_click" type="string" value="Super"/>
          <property name="focus_delay" type="int" value="250"/>
          <property name="focus_hint" type="bool" value="true"/>
          <property name="focus_new" type="bool" value="true"/>
          <property name="gap_height" type="int" value="20"/>
          <property name="gap_width" type="int" value="20"/>
          <property name="horiz_scroll_opacity" type="bool" value="false"/>
          <property name="inactive_opacity" type="int" value="100"/>
          <property name="join_workspaces" type="bool" value="true"/>
          <property name="limit_window_size" type="string" value="0,16,1500,1500"/>
          <property name="max_override_size" type="int" value="0"/>
          <property name="miniaturize_action" type="string" value="shade"/>
          <property name="mousewheel_rollup" type="bool" value="true"/>
          <property name="move_opacity" type="int" value="100"/>
          <property name="placement_mode" type="string" value="center"/>
          <property name="placement_ratio" type="int" value="100"/>
          <property name="popup_opacity" type="int" value="100"/>
          <property name="prevent_focus_stealing" type="bool" value="true"/>
          <property name="raise_delay" type="int" value="250"/>
          <property name="raise_on_focus" type="bool" value="true"/>
          <property name="raise_on_hover" type="bool" value="false"/>
          <property name="repeat_inactive" type="bool" value="true"/>
          <property name="resize_opacity" type="int" value="100"/>
          <property name="scroll_workspaces" type="bool" value="true"/>
          <property name="shadow_delta_height" type="int" value="2"/>
          <property name="shadow_delta_width" type="int" value="2"/>
          <property name="shadow_delta_x" type="int" value="0"/>
          <property name="shadow_delta_y" type="int" value="-2"/>
          <property name="shadow_opacity" type="int" value="50"/>
          <property name="show_app_icon" type="bool" value="true"/>
          <property name="show_dock_shadow" type="bool" value="true"/>
          <property name="show_frame_shadow" type="bool" value="true"/>
          <property name="show_popup_shadow" type="bool" value="false"/>
          <property name="snap_resist" type="bool" value="false"/>
          <property name="snap_to_border" type="bool" value="true"/>
          <property name="snap_to_windows" type="bool" value="true"/>
          <property name="snap_width" type="int" value="10"/>
          <property name="sync_workspaces" type="bool" value="true"/>
          <property name="theme" type="string" value="Windows-7"/>
          <property name="tile_on_move" type="bool" value="true"/>
          <property name="title_alignment" type="string" value="center"/>
          <property name="title_font" type="string" value="JetBrains Mono 11"/>
          <property name="title_horizontal_offset" type="int" value="0"/>
          <property name="title_shadow_active" type="string" value="false"/>
          <property name="title_shadow_inactive" type="string" value="false"/>
          <property name="title_vertical_offset_active" type="int" value="0"/>
          <property name="title_vertical_offset_inactive" type="int" value="0"/>
          <property name="toggle_workspaces" type="bool" value="false"/>
          <property name="unshade_action" type="string" value="shade"/>
          <property name="use_compositing" type="bool" value="true"/>
          <property name="vblank_mode" type="string" value="auto"/>
          <property name="wheel_icon_rollup" type="bool" value="false"/>
          <property name="workspace_count" type="int" value="6"/>
          <property name="workspace_names" type="array">
            <value type="string" value="1"/>
            <value type="string" value="2"/>
            <value type="string" value="3"/>
            <value type="string" value="4"/>
            <value type="string" value="5"/>
            <value type="string" value="6"/>
          </property>
          <property name="wrap_cycle" type="bool" value="true"/>
          <property name="wrap_layout" type="bool" value="true"/>
          <property name="wrap_workspaces" type="bool" value="false"/>
          <property name="workspace_cycle" type="bool" value="true"/>
        </property>
      </channel>
    '';

    "xfce4/xfconf/xfce-perchannel-xml/xsettings.xml".text = ''
      <?xml version="1.0" encoding="UTF-8"?>
      <channel name="xsettings" version="1.0">
        <property name="Net" type="empty">
          <property name="ThemeName" type="string" value="Windows-7"/>
          <property name="IconThemeName" type="string" value="Windows-10"/>
          <property name="DoubleClickTime" type="int" value="250"/>
          <property name="DoubleClickDistance" type="int" value="5"/>
          <property name="DndDragThreshold" type="int" value="8"/>
          <property name="CursorBlink" type="bool" value="true"/>
          <property name="CursorBlinkTime" type="int" value="1200"/>
          <property name="SoundThemeName" type="string" value="freedesktop"/>
          <property name="EnableEventSounds" type="bool" value="false"/>
          <property name="EnableInputFeedbackSounds" type="bool" value="false"/>
        </property>
        <property name="Xft" type="empty">
          <property name="DPI" type="int" value="-1"/>
          <property name="Antialias" type="int" value="1"/>
          <property name="Hinting" type="int" value="1"/>
          <property name="HintStyle" type="string" value="hintslight"/>
          <property name="RGBA" type="string" value="rgb"/>
        </property>
        <property name="Gtk" type="empty">
          <property name="CursorThemeName" type="string" value="Adwaita"/>
          <property name="CursorThemeSize" type="int" value="24"/>
          <property name="DecorationLayout" type="string" value="menu:minimize,maximize,close"/>
          <property name="FontName" type="string" value="JetBrains Mono 11"/>
          <property name="IconThemeName" type="string" value="Windows-10"/>
          <property name="KeyThemeName" type="string" value="/usr/share/themes/Windows-7/gtk-3.0/gtk-keys.css"/>
          <property name="ThemeName" type="string" value="Windows-7"/>
          <property name="ToolbarStyle" type="string" value="icons"/>
        </property>
      </channel>
    '';

    "xfce4/xfconf/xfce-perchannel-xml/xfce4-keyboard-shortcuts.xml".text = ''
      <?xml version="1.0" encoding="UTF-8"?>
      <channel name="xfce4-keyboard-shortcuts" version="1.0">
        <property name="commands" type="empty">
          <property name="default" type="empty">
            <property name="&lt;Alt&gt;F1" type="string" value="xfce4-popup-whiskermenu"/>
            <property name="&lt;Alt&gt;F2" type="string" value="xfce4-appfinder --collapsed"/>
            <property name="&lt;Alt&gt;F3" type="string" value="xfce4-appfinder"/>
            <property name="&lt;Primary&gt;&lt;Alt&gt;Delete" type="string" value="xflock4"/>
            <property name="&lt;Primary&gt;&lt;Alt&gt;l" type="string" value="xflock4"/>
            <property name="&lt;Primary&gt;&lt;Alt&gt;t" type="string" value="exo-open --launch TerminalEmulator"/>
            <property name="&lt;Super&gt;e" type="string" value="thunar"/>
            <property name="&lt;Super&gt;t" type="string" value="kitty"/>
            <property name="&lt;Super&gt;q" type="string" value="xkill"/>
            <property name="XF86Display" type="string" value="xfce4-display-settings --minimal"/>
            <property name="Print" type="string" value="xfce4-screenshooter"/>
            <property name="&lt;Shift&gt;Print" type="string" value="xfce4-screenshooter --region"/>
          </property>
        </property>
        <property name="xfwm4" type="empty">
          <property name="default" type="empty">
            <property name="&lt;Alt&gt;F4" type="string" value="close_window_key"/>
            <property name="&lt;Alt&gt;F7" type="string" value="move_window_key"/>
            <property name="&lt;Alt&gt;F8" type="string" value="resize_window_key"/>
            <property name="&lt;Alt&gt;F9" type="string" value="hide_window_key"/>
            <property name="&lt;Alt&gt;F10" type="string" value="maximize_window_key"/>
            <property name="&lt;Alt&gt;F11" type="string" value="fullscreen_key"/>
            <property name="&lt;Alt&gt;F12" type="string" value="above_key"/>
            <property name="&lt;Alt&gt;Tab" type="string" value="cycle_windows_key"/>
            <property name="&lt;Alt&gt;&lt;Shift&gt;Tab" type="string" value="cycle_reverse_windows_key"/>
            <property name="&lt;Control&gt;&lt;Alt&gt;Down" type="string" value="down_workspace_key"/>
            <property name="&lt;Control&gt;&lt;Alt&gt;Left" type="string" value="left_workspace_key"/>
            <property name="&lt;Control&gt;&lt;Alt&gt;Right" type="string" value="right_workspace_key"/>
            <property name="&lt;Control&gt;&lt;Alt&gt;Up" type="string" value="up_workspace_key"/>
            <property name="&lt;Control&gt;&lt;Alt&gt;d" type="string" value="show_desktop_key"/>
            <property name="&lt;Super&gt;d" type="string" value="show_desktop_key"/>
            <property name="&lt;Super&gt;f" type="string" value="maximize_window_key"/>
            <property name="&lt;Primary&gt;&lt;Alt&gt;End" type="string" value="move_to_next_workspace_key"/>
            <property name="&lt;Primary&gt;&lt;Alt&gt;Home" type="string" value="move_to_prev_workspace_key"/>
            <property name="&lt;Super&gt;&lt;Shift&gt;q" type="string" value="close_window_key"/>
          </property>
        </property>
      </channel>
    '';

    "xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml".text = ''
      <?xml version="1.0" encoding="UTF-8"?>
      <channel name="xfce4-desktop" version="1.0">
        <property name="backdrop" type="empty">
          <property name="screen0" type="empty">
            <property name="monitoreDP-1" type="empty">
              <property name="workspace0" type="empty">
                <property name="color-style" type="int" value="0"/>
                <property name="image-style" type="int" value="5"/>
                <property name="last-image" type="string" value="${config.home.homeDirectory}/Pictures/Wallpapers/WhiteRed.png"/>
              </property>
            </property>
            <property name="monitorHDMI-A-1" type="empty">
              <property name="workspace0" type="empty">
                <property name="color-style" type="int" value="0"/>
                <property name="image-style" type="int" value="5"/>
                <property name="last-image" type="string" value="${config.home.homeDirectory}/Pictures/Wallpapers/WhiteRed.png"/>
              </property>
            </property>
          </property>
        </property>
      </channel>
    '';

    "xfce4/panel/default.xml".text = ''
      <?xml version="1.0" encoding="UTF-8"?>
      <channel name="xfce4-panel" version="1.0">
        <property name="configver" type="int" value="2"/>
        <property name="panels" type="array">
          <value type="int" value="1"/>
          <property name="panel-1" type="empty">
            <property name="position" type="string" value="p=6;x=0;y=0"/>
            <property name="length" type="uint" value="100"/>
            <property name="position-locked" type="bool" value="true"/>
            <property name="icon-size" type="uint" value="24"/>
            <property name="size" type="uint" value="36"/>
            <property name="plugin-ids" type="array">
              <value type="int" value="1"/>
              <value type="int" value="2"/>
              <value type="int" value="3"/>
              <value type="int" value="4"/>
              <value type="int" value="5"/>
              <value type="int" value="6"/>
              <value type="int" value="7"/>
            </property>
            <property name="background-style" type="uint" value="0"/>
            <property name="background-alpha" type="uint" value="100"/>
          </property>
        </property>
        <property name="plugins" type="empty">
          <property name="plugin-1" type="string" value="whiskermenu"/>
          <property name="plugin-2" type="string" value="tasklist">
            <property name="flat-buttons" type="bool" value="false"/>
            <property name="show-handle" type="bool" value="false"/>
            <property name="show-labels" type="bool" value="true"/>
            <property name="show-only-visible" type="bool" value="true"/>
            <property name="grouping" type="uint" value="1"/>
            <property name="sort-order" type="uint" value="0"/>
          </property>
          <property name="plugin-3" type="string" value="separator">
            <property name="style" type="uint" value="0"/>
            <property name="expand" type="bool" value="true"/>
          </property>
          <property name="plugin-4" type="string" value="pulseaudio"/>
          <property name="plugin-5" type="string" value="notification-plugin"/>
          <property name="plugin-6" type="string" value="clipman"/>
          <property name="plugin-7" type="string" value="datetime">
            <property name="digital-format" type="string" value="%d/%m/%Y %H:%M"/>
          </property>
        </property>
      </channel>
    '';

    "xfce4/terminal/terminalrc".text = ''
      [Configuration]
      FontName=JetBrains Mono 11
      MiscAlwaysShowTabs=FALSE
      MiscBell=FALSE
      MenubarVisibleDefault=FALSE
      ScrollingUnlimited=TRUE
    '';

    "Thunar/uca.xml".text = ''
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

    "Thunar/thunar.xml".text = ''
      <?xml version="1.0" encoding="UTF-8"?>
      <channel name="thunar" version="1.0">
        <property name="shortcuts-view-icon-size" type="string" value="THUNAR_ICON_SIZE_SMALL"/>
        <property name="misc-open-new-window-as-tab" type="bool" value="true"/>
        <property name="last-view" type="string" value="ThunarIconView"/>
        <property name="last-icon-view-zoom-level" type="string" value="THUNAR_ZOOM_NORMAL"/>
        <property name="last-details-view-zoom-level" type="string" value="THUNAR_ZOOM_NORMAL"/>
        <property name="last-separator-position" type="int" value="170"/>
        <property name="last-window-width" type="int" value="800"/>
        <property name="last-window-height" type="int" value="600"/>
        <property name="last-window-maximized" type="bool" value="true"/>
        <property name="misc-thumbnail-draw-frames" type="bool" value="true"/>
        <property name="misc-thumbnail-mode" type="string" value="THUNAR_THUMBNAIL_MODE_ALWAYS"/>
      </channel>
    '';
  };

  # GTK theme configuration
  gtk = {
    enable = true;

    theme = {
      name = "Windows-7";
      package = pkgs.b00merang-windows-7;
    };

    iconTheme = {
      name = "Windows-10";
      package = pkgs.windows10-icons;
    };

    font = {
      name = "JetBrains Mono";
      size = 11;
    };
  };

  # Start xfce4-session and required services with dbus
  systemd.user.targets.xfce4 = {
    Unit = {
      Description = "XFCE session target";
      BindsTo = [ "graphical-session.target" ];
      Wants = [ "graphical-session-pre.target" ];
      After = [ "graphical-session-pre.target" ];
    };
  };

  # Dynamic workspaces as a systemd user service
  systemd.user.services.dynamic-workspaces = {
    Unit = {
      Description = "Dynamic Workspaces for XFCE";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.dynamic-workspaces}/bin/dynamic-workspaces";
      Restart = "on-failure";
      RestartSec = "2";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  # Session variables
  home.sessionVariables = {
    XDG_CURRENT_DESKTOP = "XFCE";
    XDG_SESSION_DESKTOP = "XFCE";
    XDG_SESSION_TYPE = "x11";
    GTK_THEME = "Windows-7";
    QT_QPA_PLATFORM = "xcb";
    QT_STYLE_OVERRIDE = "gtk2";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
  };

  # Kitty config from existing theme
  xdg.configFile."kitty".source = ../components/WhiteBlackSchema/kitty;

  # Wallpaper
  home.file."Pictures/Wallpapers/WhiteRed.png".source = ../components/WhiteBlackSchema/WhiteRed.png;
}
