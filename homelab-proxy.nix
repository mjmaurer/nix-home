{ pkgs, ... }:

{
  imports = [ ./common.nix ./common-linux.nix ];

  home.username = pkgs.lib.mkForce "ubuntu";

  programs.bash.sessionVariables = {
    MACHINE_NAME = "homelab-proxy";
  };
}
