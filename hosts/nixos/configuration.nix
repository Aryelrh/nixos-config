#===============================================================================
# NixOS — Machine Dispatcher
#
# Automatically detects the current hardware and imports the matching
# machine-specific configuration.
#
# Supported machines:
#   - ThinkBook  → ./thinkbook.nix    (Lenovo ThinkBook, laptop actual)
#   - MacBook    → ./macbook.nix      (MacBook Pro 2019, Intel T2)
#===============================================================================

{ config, pkgs, lib, ... }:

let
  #--------------------------------------------------------------
  # Detect machine via DMI product name
  #--------------------------------------------------------------
  productName = builtins.readFile "/sys/class/dmi/id/product_name";
in
{
  imports = [
    if lib.hasPrefix "ThinkBook" productName then ./thinkbook.nix
    else if lib.hasPrefix "MacBook" productName then ./macbook.nix
    else
      builtins.abort "Unsupported machine: ${productName}"
  ];
}
