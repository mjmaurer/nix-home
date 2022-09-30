{ pkgs, config, ... }:

{
  imports = [ ./common.nix ./common-mac.nix ];

  home.username = pkgs.lib.mkForce "michaelmaurer";

  services.gpg-agent.enable = false;

  programs.bash = {
    sessionVariables = { MACHINE_NAME = "smac"; };
    shellAliases = {
      "la" = "ls -A -G";
      "ls" = "ls -G";
    };
  };
}
