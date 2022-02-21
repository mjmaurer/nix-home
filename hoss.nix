{ pkgs, ... }:

{
  imports = [ ./common.nix ];
  programs.bash.sessionVariables = { MACHINE_NAME = "hoss"; };
}
