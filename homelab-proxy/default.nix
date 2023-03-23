{ config, pkgs, ... }:

let
  proxyAddr = "howell.haus";
in
{
  imports = [ ../common.nix ../common-linux.nix ];

  home.username = pkgs.lib.mkForce "ubuntu";

  # home.packages = with pkgs; [
  # ];

  programs.bash.sessionVariables = {
    MACHINE_NAME = "homelab-proxy";
    DOMAIN = "howell.haus";
  };

}
