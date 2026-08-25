#===============================================================================
# GREEN-BLACK SCHEMA — Waybar + Fuzzel + Kitty + Wallpaper
#===============================================================================
# Módulo de Home Manager específico para macbook-air. Se importa únicamente
# desde el bloque `nixosConfigurations.macbook-air` del flake, así que no
# afecta a thinkbook ni a macbook.
#
# - Despliega waybar (config, estilo y scripts ejecutables), fuzzel y kitty
#   usando los archivos de este directorio como fuente única.
# - Arranca waybar junto con sway y aplica el wallpaper Blue.jpg de forma
#   persistente (reintenta hasta que swww-daemon esté listo).
# - Super+Espacio lanza fuzzel en vez de rofi.
# - Acentos azules pastel oscuro (#89B4FA) en bordes enfocados de sway.
#===============================================================================

{ pkgs, lib, ... }:

{
  #=============================================================================
  # PAQUETES DEL ESCRITORIO
  #=============================================================================

  home.packages = with pkgs; [
    waybar
    fuzzel
    awww          # wallpaper daemon (antes "swww": awww-daemon / awww img)
    playerctl     # módulo mpris de waybar
    bluetui       # on-click del módulo bluetooth
    nerd-fonts.jetbrains-mono
  ];

  #=============================================================================
  # DESPLIEGUE DE CONFIGURACIONES
  #=============================================================================

  xdg.configFile = {
    #------------------
    # Kitty
    #------------------
    "kitty/kitty.conf".source = ./kitty/kitty.conf;
    "kitty/colors.conf".source = ./kitty/colors.conf;

    #------------------
    # Fuzzel
    #------------------
    "fuzzel/fuzzel.ini".source = ./fuzzel/fuzzel.ini;

    #------------------
    # Waybar
    #------------------
    "waybar/config".source = ./waybar/config;
    "waybar/style.css".source = ./waybar/style.css;

    "waybar/scripts/power-profile-status.sh" = {
      source = ./waybar/scripts/power-profile-status.sh;
      executable = true;
    };
    "waybar/scripts/power-profile.sh" = {
      source = ./waybar/scripts/power-profile.sh;
      executable = true;
    };
    "waybar/scripts/mic-status.sh" = {
      source = ./waybar/scripts/mic-status.sh;
      executable = true;
    };
    "waybar/scripts/mic-toggle.sh" = {
      source = ./waybar/scripts/mic-toggle.sh;
      executable = true;
    };

    # Variables CSS que style.css importa vía "../colors/colors.css"
    "colors/colors.css".source = ./colors/colors.css;

    #------------------
    # Wallpaper (persistente al iniciar sway)
    #------------------
    "sway/wallpaper.jpg".source = ../wallpapers/Blue.jpg;

    #------------------
    # Layout teclado es-mac a nivel usuario
    # libxkbcommon (sway) busca SIEMPRE en ~/.config/xkb antes que en el
    # árbol del sistema, sin depender de XKB_CONFIG_ROOT en el entorno
    #------------------
    "xkb/symbols/es-mac".source = ../../../../hosts/nixos/es-mac.xkb;
  };

  #=============================================================================
  # INTEGRACIÓN CON SWAY (solo macbook-air)
  #=============================================================================

  wayland.windowManager.sway = {
    config = {
      # Super+Espacio → fuzzel (antes rofi)
      keybindings = {
        "Mod4+space" = lib.mkForce "exec fuzzel";
      };

      # Startup completo para este host: wallpaper persistente + waybar
      startup = lib.mkForce [
        { command = "awww-daemon"; }
        {
          command =
            "for i in $(seq 1 50); do awww query >/dev/null 2>&1 && break; sleep 0.2; done; " +
            "awww img ~/.config/sway/wallpaper.jpg";
        }
        { command = "pkill -x waybar || true; exec waybar"; }
        { command = "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"; }
        { command = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"; }
        { command = "swayidle --timeout 600 'swaymsg \"output * dpms off\"' --refresh 5 'swaymsg \"output * dpms on\"' --wob before-sleep 'swaylock -f'"; }
      ];

      # Azul pastel oscuro en lugar de rojo en los bordes enfocados
      colors.focused = {
        border = lib.mkForce "#89B4FA";
        childBorder = lib.mkForce "#89B4FA";
      };
    };
  };
}
