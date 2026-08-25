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
      theme = {
        mode = "system";
        light = "Min Theme";
        dark = "Min Theme";
      };
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

  programs.git.settings.credential = {
    helper = "${pkgs.git-credential-manager}/bin/git-credential-manager";
    credentialStore = "secretservice";
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
