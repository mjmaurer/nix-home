{ pkgs, ... }:

{
  imports = [ ./home.nix ];
  programs.bash.sessionVariables = {
      MACHINE_NAME = "hoss";
  };
}