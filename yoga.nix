{ pkgs, ... }:

{
  imports = [ ./common.nix ./common-wsl.nix ];
  programs.bash.sessionVariables = {
    MACHINE_NAME = "yoga";
    WIN_DOWNLOADS = "/mnt/c/Users/mjmau/Downloads/";
  };
}
