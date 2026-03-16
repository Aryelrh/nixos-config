{ pkgs, inputs, ... }:

#let
 # hyprexpo = inputs.hyprland-plugins.packages.${pkgs.system}.hyprexpo;
#in
{

  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;

    extraConfig = ''
      env = XDG_CURRENT_DESKTOP,Hyprland
      env = XDG_SESSION_DESKTOP,Hyprland
      env = XDG_SESSION_TYPE,wayland
      env = XCURSOR_THEME,Bibata-Modern-Ice
      env = XCURSOR_SIZE,24
      env = QT_QPA_PLATFORM,wayland
      env = QT_WAYLAND_DISABLE_WINDOWDECORATION,1
      env = QT_LOGGING_RULES,*.debug=false;qt.qpa.*=false
     
      #Fixing the crash (Intel Iris Xe specific)
      env = HYPRLAND_NO_HARDWARE_CURSORS,1   
      env = WLR_NO_HARDWARE_CURSORS,1
      env = MESA_LOADER_DRIVER_OVERRIDE,iris
      env = MESA_NO_ERROR,1
      env = LIBGL_ALWAYS_INDIRECT,0

      monitor=eDP-1,1920x1080@60.00,0x0,1.00
      monitor=HDMI-A-1,1920x1080@100.00,1920x0,1.00

      exec-once = waybar -c ~/.config/waybar/config -s ~/.config/waybar/style.css &
      exec-once = nm-applet &
      exec-once = dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
      exec-once = gnome-keyring-daemon --start --components=secrets
      exec-once = ${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1 &
      exec-once = swww-daemon
      exec-once = swww img ~/Pictures/Wallpapers/GreenBlack.jpg
      exec-once = /usr/libexec/xdg-desktop-portal -r
      exec-once = xdg-desktop-portal-hyprland
      exec-once = xsettingsd
      exec-once = hypridle

      input {
        kb_layout = us
        kb_variant = intl
        accel_profile = adaptive
        sensitivity = 0.1
        scroll_points = 0.5, 1.0, 2.0
        touchpad {
          natural_scroll = true
          scroll_factor = 1
        }
      }
      
      #Enable full logs
      debug {
        disable_logs = false
        enable_stdout_logs = true
      }

      #Fixing crash
      cursor {
        no_hardware_cursors = true
      }

      misc {
        disable_hyprland_logo = true
        force_default_wallpaper = 0
        disable_splash_rendering = true
      }

      general {
        gaps_in = 3
        gaps_out = 5
        border_size = 2
        col.active_border = rgba(7ad3beff)
      }

      decoration {
        rounding = 5
        rounding_power = 2
      }

      gestures {
        workspace_swipe_distance = 1000
        workspace_swipe_cancel_ratio = 0.15
        workspace_swipe_min_speed_to_force = 5
        workspace_swipe_direction_lock = true
        workspace_swipe_direction_lock_threshold = 10
        workspace_swipe_create_new = true
        workspace_swipe_invert = true
        #workspace_swipe_distance = 1000

        gesture = 3, horizontal, workspace
      }

      animations {
        enabled = true
        animation = workspaces, 1, 9, default, slide
      }

      #Set a mod key
      $mod = SUPER
      
      # Apps
      bind = $mod, T, exec, kitty
      bind = $mod, Q, killactive,
      bind = $mod, Space, exec, rofi -show drun
      bind = $mod, E, exec, nautilus
      bind = $mod, D, exec, fuzzel

      # Session
      bind = $mod SHIFT, Q, exit,
      bind = $mod, F7, exec, /toggle-monitors.sh

      # Windows
      bind = $mod, F, fullscreen, 0
      bind = $mod, V, togglefloating,
      bind = $mod, mouse_down, workspace, e-1
      bind = $mod, mouse_up, workspace, e+1

      # Move / resize
      bindm = $mod, mouse:272, movewindow
      bindm = $mod, mouse:273, resizewindow

      # Persistent workspaces (fija 9 workspaces para el grid 3x3)
      workspace = 1, persistent:false
      workspace = 2, persistent:false
      workspace = 3, persistent:false
      workspace = 4, persistent:false
      workspace = 5, persistent:false
      workspace = 6, persistent:false
      workspace = 7, persistent:false
      workspace = 8, persistent:false
      workspace = 9, persistent:false

      # Workspaces
      bind = SUPER, 1, workspace, 1
      bind = SUPER, 2, workspace, 2
      bind = SUPER, 3, workspace, 3
      bind = SUPER, 4, workspace, 4
      bind = SUPER, 5, workspace, 5
      bind = SUPER, 6, workspace, 6
      bind = SUPER, 7, workspace, 7
      bind = SUPER, 8, workspace, 8
      bind = SUPER, 9, workspace, 9
      bind = SUPER SHIFT, 1, movetoworkspace, 1
      bind = SUPER SHIFT, 2, movetoworkspace, 2
      bind = SUPER SHIFT, 3, movetoworkspace, 3
      bind = SUPER SHIFT, 4, movetoworkspace, 4
      bind = SUPER SHIFT, 5, movetoworkspace, 5
      bind = SUPER SHIFT, 6, movetoworkspace, 6
      bind = SUPER SHIFT, 7, movetoworkspace, 7
      bind = SUPER SHIFT, 8, movetoworkspace, 8
      bind = SUPER SHIFT, 9, movetoworkspace, 9

      # Monitors
      bind = SUPER, F7, exec, hyprmon --profile Laptop-only
      bind = SUPER, F8, exec, hyprmon --profile External-only

      # Screenshot
      bind = SUPER SHIFT, S, exec, grimblast --freeze copy area

      # Audio
      bind = , XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
      bind = , XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
      bind = , XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
      bind = , XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle

      # Backlight
      bind = , XF86MonBrightnessDown, exec, brightnessctl set 5%-
      bind = , XF86MonBrightnessUp, exec, brightnessctl set 5%+

      # Lock
      bind = SUPER SHIFT, L, exec, ~/.config/hypr/scripts/suspend.sh
    '';
  };
}
