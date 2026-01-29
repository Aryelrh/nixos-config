{ pkgs, ... }:

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

    #Neovim setup (LSP, search, etc...)
    pkgs.ripgrep
    pkgs.fd
    pkgs.nodejs
    pkgs.lua-language-server
    pkgs.pyright
    pkgs.clang-tools
    pkgs.rust-analyzer
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
  
  #Declarative symlinks for Lua config
  home.file.".config/nvim".source = nvimConfigPath;

  #Alias
  programs.bash = {
    enable = true;
  
    shellAliases = {
      hm = "cd ~/nixos-config && sudo nixos-rebuild switch --flake .#nixos";
      gc = "sudo nix-collect-garbage -d";
    };
  };
}
