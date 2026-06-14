#===============================================================================
# NixOS — Machine Dispatcher
#
# Automatically detects the current machine by hostname and imports the
# matching configuration.
#
# Supported machines:
#   hostname | config                     | device
#   ---------+----------------------------+-------------------------------
#   nixos    | ./thinkbook.nix            | Lenovo ThinkBook (laptop actual)
#   macbook  | ./macbook.nix              | MacBook Pro 2019 (Intel T2)
#===============================================================================

{ config, pkgs, lib, ... }:

let
  currentHost = lib.trim (builtins.readFile "/etc/hostname");
in
{
  imports = [
    (if currentHost == "nixos" then ./thinkbook.nix
     else if currentHost == "macbook" then ./macbook.nix
     else builtins.abort "Unknown hostname '${currentHost}' — add it to hosts/nixos/configuration.nix")
  ];
}
