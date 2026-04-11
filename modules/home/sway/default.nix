{ pkgs, ... }:

{
  wayland.windowManager.sway = {
    enable = true;

    config = {
      modifier = "Mod4";

      # Input configuration
      input = {
        "type:keyboard" = {
          xkb_layout = "us";
          xkb_variant = "intl";
        };
        "type:touchpad" = {
          natural_scroll = "enabled";
          scroll_factor = "1";
        };
        "type:pointer" = {
          accel_profile = "adaptive";
          pointer_accel = "0.1";
        };
      };

      # Monitor configuration
      output = {
        "eDP-1" = {
          resolution = "1920x1080";
          position = "0 0";
          scale = "1.0";
        };
        "HDMI-A-1" = {
          resolution = "1920x1080";
          position = "1920 0";
          scale = "1.0";
        };
      };

      # Appearance
      gaps = {
        inner = 3;
        outer = 5;
      };

      # Disable default sway bar
      bars = [];

      colors = {
        focused = {
          background = "#141414";
          border = "#FF6B6B";
          childBorder = "#FF6B6B";
          indicator = "#FF6B6B";
          text = "#ffffff";
        };
       # focusedInactive = {
         # background = "#141414";
         # border = "#7ad3be";
         # childBorder = "#7ad3be";
         # indicator = "#7ad3be";
         # text = "#ffffff";
       # };
       # unfocused = {
         # background = "#141414";
         # border = "#444444";
         # childBorder = "#444444";
         # indicator = "#444444";
         # text = "#888888";
       # };
      };

      # Apps
      keybindings = let modifier = "Mod4"; in {
        "${modifier}+t" = "exec kitty";
        "${modifier}+q" = "kill";
        "${modifier}+space" = "exec rofi -show drun";
        "${modifier}+e" = "exec nautilus";
        "${modifier}+d" = "exec fuzzel";

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

        # Lock
        "${modifier}+shift+l" = "exec ~/.config/sway/scripts/suspend.sh";
      };

      # Startup commands
      startup = [
        { command = "waybar"; }
        { command = "autotiling-rs"; }
        { command = "nm-applet"; }
        { command = "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"; }
        { command = "gnome-keyring-daemon --start --components=secrets"; }
        { command = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"; }
        { command = "swww-daemon"; }
        { command = "swww img ~/Pictures/Wallpapers/WhiteRed.png"; }
        { command = "/usr/libexec/xdg-desktop-portal -r"; }
        { command = "xdg-desktop-portal-wlr"; }
        { command = "xsettingsd"; }
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
     
      for_window [title="Worms W.M.D"] floating enable
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

  # Symlinks to WhiteBlackSchema configs
  home.file.".config/kitty".source = ../components/WhiteBlackSchema/kitty;
  home.file.".config/waybar".source = ../components/WhiteBlackSchema/waybar;
  home.file.".config/fuzzel".source = ../components/WhiteBlackSchema/fuzzel;
  home.file.".config/fontconfig".source = ../components/WhiteBlackSchema/fontconfig;

  # Wallpaper symlink
  home.file."Pictures/Wallpapers/WhiteRed.png".source = ../components/WhiteBlackSchema/WhiteRed.png;

  # Swayidle service
  services.swayidle = {
    enable = true;
    events = {
      "before-sleep" = "${pkgs.swaylock}/bin/swaylock -f -c 1a1a1a";
    };
    timeouts = [
      {
        timeout = 300;
        command = "${pkgs.swaylock}/bin/swaylock -f -c 1a1a1a";
      }
      {
        timeout = 600;
        command = "${pkgs.sway}/bin/swaymsg 'output * dpms off'";
        resumeCommand = "${pkgs.sway}/bin/swaymsg 'output * dpms on'";
      }
    ];
  };

  # Suspend script
  home.file.".config/sway/scripts/suspend.sh" = {
    source = ./scripts/suspend.sh;
    executable = true;
  };

}
