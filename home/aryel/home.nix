{ pkgs, ... }:

{
  #General config
  home.stateVersion = "26.05";
  programs.home-manager.enable = true;
  home.username = "aryel";
  home.homeDirectory = "/home/aryel";
  
  #Install packages
  home.packages = [
    pkgs.vscode
    pkgs.spotify
    pkgs.github-desktop
    pkgs.hyprmon
    pkgs.openjdk21
    pkgs.maven
    pkgs.obsidian
    pkgs.ani-cli
    pkgs.swww
    pkgs.bottom

    #Neovim setup
    pkgs.ripgrep
    pkgs.fd
    pkgs.nodejs
    pkgs.lua-language-server
    pkgs.pyright
    pkgs.clang-tools
    pkgs.rust-analyzer
  ];

  #Modules imports
  imports = [
    ../../modules/home/neovim
  ];
  
  #Cursor
  home.pointerCursor = {
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
    size = 24;
  };   

  #Path variables
  home.sessionVariables = {
    JAVA_HOME = "${pkgs.openjdk21}";
    MAVEN_HOME = "${pkgs.maven}";
  };

  #Alias
  programs.bash = {
    enable = true;
  
    shellAliases = {
      hm = "nix run ~/nix#home-manager -- switch --flake ~/nix#aryel";
      rebuild = "sudo nixos-rebuild switch";
    };
  };
}
