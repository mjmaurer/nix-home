{ pkgs, ... }:

{
  imports = [ ./common.nix ];

  services.gpg-agent.enable = false;

  programs.bash.sessionVariables = {
    sessionVariables = { MACHINE_NAME = "smac"; };
    shellAliases = {
      "la" = "ls -A -G";
      "ls" = "ls -G";
    };
  };
}
