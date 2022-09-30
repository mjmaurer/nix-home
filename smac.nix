{ pkgs, ... }:

{
  imports = [ ./common.nix ./common-mac.nix ];

  services.gpg-agent.enable = false;

  programs.bash = {
    sessionVariables = { MACHINE_NAME = "smac"; };
    shellAliases = {
      "la" = "ls -A -G";
      "ls" = "ls -G";
    };
  };
}
