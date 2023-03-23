{ config, pkgs, ... }:

let
  domain = "howell.haus";
in
{
  imports = [ ../common.nix ../common-linux.nix ];

  home.username = pkgs.lib.mkForce "ubuntu";

  # home.packages = with pkgs; [
  # ];

  programs.bash.sessionVariables = {
    MACHINE_NAME = "homelab-proxy";
    # See docker-compose for most environment variables needed 
    DOMAIN = domain;
    VOUCH_DOMAINS = domain;
    OAUTH_CALLBACK_URL = "https://${domain}/auth";
  };

  programs.bash.initExtra = ''
    whitelist_user () {
      term="$1"

      if [ -z "VOUCH_WHITELIST" ]; then
          export VOUCH_WHITELIST="${term}"
      else
          export VOUCH_WHITELIST="VOUCH_WHITELIST,${term}"
      fi
      echo "Make sure to reload vouch"
    }
    source_env () {
      export $(grep -v '^#' .env | xargs)
    }
  '';

}
