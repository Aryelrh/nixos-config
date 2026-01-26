{ pkgs, ... }:

{
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;

  home.username = "aryel";
  home.homeDirectory = "/home/aryel";

  home.packages = [
    pkgs.vscode
    pkgs.spotify
    pkgs.github-desktop
    pkgs.hyprmon
    pkgs.openjdk21
    pkgs.maven
    pkgs.obsidian
    pkgs.ani-cli
  ];
  
  home.pointerCursor = {
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
    size = 24;
  };   

  home.sessionVariables = {
    JAVA_HOME = "${pkgs.openjdk21}";
    MAVEN_HOME = "${pkgs.maven}";
  };

  programs.bash = {
    enable = true;
  
    shellAliases = {
      hm = "nix run ~/nix#home-manager -- switch --flake ~/nix#aryel";
      rebuild = "sudo nixos-rebuild switch";
    };
  };
}
