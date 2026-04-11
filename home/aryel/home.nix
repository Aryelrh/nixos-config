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
    pkgs.waybar
    pkgs.dunst
    pkgs.autotiling-rs
    
    #Utilities
    pkgs.pavucontrol
    pkgs.fuzzel
    pkgs.lavat
    pkgs.swayimg
    pkgs.mpv
    pkgs.cmus
    pkgs.vlc
    pkgs.system-config-printer

    #Apss
    pkgs.vscode
    pkgs.spotify
    pkgs.github-desktop
    pkgs.maven
    pkgs.obsidian
    pkgs.ani-cli
    pkgs.swww
    pkgs.bottom
    pkgs.jetbrains.clion
    pkgs.discordo
    pkgs.onlyoffice-desktopeditors
    pkgs.mongodb-compass
    pkgs.dolphin-emu
    pkgs.postman
    pkgs.dbeaver-bin
 
    #Java
    pkgs.jdk21
    
    #R Tooling
    #RStudio with software rendering
    (pkgs.writeShellScriptBin "rstudio" ''
      export QTWEBENGINE_CHROMIUM_FLAGS="--disable-gpu"
      exec ${pkgs.rstudio}/bin/rstudio "$@"
    '')
    pkgs.pandoc

    #Rust
    pkgs.rustc
    pkgs.cargo
    pkgs.rustfmt
    pkgs.clippy

    #Development tool 
    pkgs.gcc           
    pkgs.pkg-config 
    pkgs.cmake

    #Python
    pkgs.python3

    #Neovim setup (LSP, search, etc...)
    pkgs.ripgrep
    pkgs.fd
    pkgs.nodejs
    pkgs.nodePackages.typescript-language-server
    pkgs.lua-language-server
    pkgs.pyright
    pkgs.clang-tools
    pkgs.rust-analyzer
    pkgs.jdt-language-server
    pkgs.nodePackages.vscode-langservers-extracted  # HTML, CSS, JSON LSP
    pkgs.sqls                                         # SQL LSP
    
    #Neovim formatters
    pkgs.stylua                  # Lua formatter
    pkgs.nodePackages.prettier      # JavaScript/TypeScript formatter
    pkgs.black                   # Python formatter
    pkgs.isort                   # Python import sorter
    pkgs.google-java-format      # Java formatter

    #LaTeX PDF Viewer
    pkgs.zathura                           # PDF viewer with SyncTeX (forward/inverse search)                             # required by latexmk
    
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

  #Zathura PDF viewer (used by vimtex for forward/inverse search via SyncTeX)
  programs.zathura = {
    enable = true;
    options = {
      synctex             = true;   # vimtex passes --synctex-editor-cmd automatically on forward search
      selection-clipboard = "clipboard";
      recolor             = false;
    };
  };

  imports = [
    ../../modules/home/sway/default.nix
  ];

  #Alias
  programs.bash = {
    enable = true;
  
    shellAliases = {
      hm = "cd ~/nixos-config && sudo nixos-rebuild switch --flake .#nixos";
      gc = "sudo nix-collect-garbage -d";
   };
  };
}

