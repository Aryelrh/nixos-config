{ pkgs, lib, keyboard ? { layout = "us"; variant = "intl"; }, ... }:

{
  wayland.windowManager.sway = {
    enable = true;

    config = {
      modifier = "Mod4";

      # Input configuration
      # `keyboard` llega vía home-manager.extraSpecialArgs desde cada host del flake
      input = {
        "type:keyboard" = {
          xkb_layout = keyboard.layout;
        } // lib.optionalAttrs (keyboard.variant or "" != "") {
          xkb_variant = keyboard.variant;
        };
        "type:touchpad" = {
          tap = "enabled";
          natural_scroll = "enabled";
          scroll_factor = "1";
        };
        "type:pointer" = {
          accel_profile = "adaptive";
          pointer_accel = "0.1";
        };
      };

      # Monitor configuration — MacBook Air 2015 built-in display
      output = {
        "eDP-1" = {
          resolution = "1440x900";
          position = "0 0";
          scale = "1.0";
        };
      };

      # Appearance
      gaps = {
        inner = 2;
        outer = 3;
      };

      # Disable default sway bar
      bars = [];

      # Minimal colors
      colors = {
        focused = {
          background = "#141414";
          border = "#FF6B6B";
          childBorder = "#FF6B6B";
          indicator = "#FF6B6B";
          text = "#ffffff";
        };
      };

      # Apps — keybindings
      keybindings = let modifier = "Mod4"; in {
          "${modifier}+t" = "exec kitty";
          "${modifier}+q" = "kill";
          "${modifier}+space" = "exec rofi -show drun";
          "${modifier}+e" = "exec firefox";

          # Session
          "${modifier}+shift+q" = "exit";

          # Windows
          "${modifier}+f" = "fullscreen";
          "${modifier}+v" = "floating toggle";

          # Scroll through workspaces with mouse wheel while holding Mod key
          "${modifier}+button4" = "workspace prev";
          "${modifier}+button5" = "workspace next";

          # Direct mouse wheel scrolling for workspace navigation
          "button8" = "workspace prev";
          "button9" = "workspace next";

          # Move / resize
          "${modifier}+button1" = "move";
          "${modifier}+button3" = "resize";

          # Workspaces
          "${modifier}+1" = "workspace 1";
          "${modifier}+2" = "workspace 2";
          "${modifier}+3" = "workspace 3";
          "${modifier}+4" = "workspace 4";
          "${modifier}+5" = "workspace 5";
          "${modifier}+6" = "workspace 6";
          "${modifier}+7" = "workspace 7";
          "${modifier}+8" = "workspace 8";
          "${modifier}+9" = "workspace 9";

          "${modifier}+shift+1" = "move container to workspace 1; workspace 1";
          "${modifier}+shift+2" = "move container to workspace 2; workspace 2";
          "${modifier}+shift+3" = "move container to workspace 3; workspace 3";
          "${modifier}+shift+4" = "move container to workspace 4; workspace 4";
          "${modifier}+shift+5" = "move container to workspace 5; workspace 5";
          "${modifier}+shift+6" = "move container to workspace 6; workspace 6";
          "${modifier}+shift+7" = "move container to workspace 7; workspace 7";
          "${modifier}+shift+8" = "move container to workspace 8; workspace 8";
          "${modifier}+shift+9" = "move container to workspace 9; workspace 9";

          # Screenshot
          "${modifier}+shift+s" = "exec grim -g \"$(slurp)\" - | wl-copy";

          # Audio
          "XF86AudioMute" = "exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          "XF86AudioLowerVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
          "XF86AudioRaiseVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
          "XF86AudioMicMute" = "exec wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";

          # Backlight
          "XF86MonBrightnessDown" = "exec brightnessctl set 5%-";
          "XF86MonBrightnessUp" = "exec brightnessctl set 5%+";
        };

      # Startup commands — lightweight only
      startup = [
        { command = "for i in $(seq 1 30); do [ -f ~/.config/sway/wallpaper.jpg ] && break; sleep 0.2; done; swaybg -i ~/.config/sway/wallpaper.jpg -m fill"; }
        { command = "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"; }
        { command = "swayidle --timeout 600 'swaymsg \"output * dpms off\"' --refresh 5 'swaymsg \"output * dpms on\"' --wob before-sleep 'swaylock -f'"; }
        { command = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"; }
      ];
    };

    # Environment variables
    extraConfig = ''
      set $XCURSOR_THEME Bibata-Modern-Ice
      set $XCURSOR_SIZE 24

      # Remove all decorations and use only colored pixel borders
      default_border pixel 2
      default_floating_border pixel 2
      smart_borders on

      # Gestures for workspaces navigation
      bindgesture swipe:3:right workspace prev
      bindgesture swipe:3:left workspace next
    '';
  };

  # Ensure environment variables are set
  home.sessionVariables = {
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

  # Swaylock configuration
  home.file.".config/swaylock/config".source = ./config/swaylock.conf;
}
