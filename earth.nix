{ pkgs, ... }:

{
  imports = [ ./common.nix ./common-linux.nix ];

  programs.bash.sessionVariables = {
    MACHINE_NAME = "earth";
  };
}
