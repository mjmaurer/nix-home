{ pkgs, ... }:

{
  imports = [ ./common.nix ./common-mac.nix ];

  services.gpg-agent.enable = false;

  home.username = pkgs.lib.mkForce "mmaurer7";

  # TODO remove this https://github.com/nix-community/home-manager/issues/3342
  manual.manpages.enable = false;

  programs.bash = {
    sessionVariables = { MACHINE_NAME = "smac"; };
    shellAliases = {
      "la" = "ls -A -G";
      "ls" = "ls -G";
    };
  };
}
