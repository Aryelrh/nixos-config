{ pkgs, inputs, ... }:

let
  #Relative path to absolute path
  nvimConfigPath = builtins.path {
    path = ../../modules/home/nvim;
    name = "nvim-config";
  };
in
{
  #General config
  home.stateVersion = "26.05";
  programs.home-manager.enable = true;
  home.username = "aryel";
  home.homeDirectory = "/home/aryel";
  
  #Enable Neovim complete module (to avoid errors)
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
  };

  programs.direnv.enable = true;
  programs.direnv.enableBashIntegration = true;
  programs.direnv.nix-direnv.enable = true;

  #Install packages
  home.packages = [
    #Wayland essentials
    pkgs.wlr-randr
    pkgs.dunst
    
    #Utilities
    pkgs.pavucontrol
    pkgs.lavat
    pkgs.swayimg
    pkgs.mpv
    pkgs.cmus
    pkgs.vlc
    pkgs.system-config-printer

    #Apss
    pkgs.vscode
    pkgs.zed-editor
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
    
    #Wayland file picker and polkit agent
    pkgs.polkit_gnome
    
    #GSettings schemas (required by MongoDB Compass and other GNOME apps)
    pkgs.gsettings-desktop-schemas
    pkgs.glib
  ];
  home.pointerCursor = {
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
    size = 24;
  };   

  #GTK theme
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

  #Path variables
  home.sessionVariables = {
    #Java declaration also does this
    #JAVA_HOME = "${pkgs.openjdk21}";
    MAVEN_HOME = "${pkgs.maven}";
    
    #GTK4 apps theme, like Nautilus
    GTK_THEME = "Adwaita-dark";

    #Intel Iris Xe GPU optimization
    MESA_LOADER_DRIVER_OVERRIDE = "iris";
    MESA_NO_ERROR = "1";
  };
  
  #Declarative symlinks for Lua config
  home.file.".config/nvim".source = nvimConfigPath;

  imports = [
    ../../modules/home/gnome/default.nix
  ];

  #Alias
  programs.bash = {
    enable = true;
  
    shellAliases = {
      hm = "cd ~/nixos-config && sudo nixos-rebuild switch --flake .#nixos";
      gc = "sudo nix-collect-garbage -d";
      spotui = "cd ~/LazySpotify/lazyspotify && nix develop --command make";
   };
  };
}

