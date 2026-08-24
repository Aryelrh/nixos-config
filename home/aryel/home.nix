#===============================================================================
# HOME MANAGER — Aryel's User Configuration
#===============================================================================

{ pkgs, inputs, ... }:

{
  home.stateVersion = "26.05";
  programs.home-manager.enable = true;
  home.username = "aryel";
  home.homeDirectory = "/home/aryel";

  home.packages = with pkgs; [
    wlr-randr
    dunst
    pavucontrol
    swayimg
  ];

  #=============================================================================
  # FONTCONFIG
  #=============================================================================

  fonts.fontconfig = {
    enable = false;
  };
}