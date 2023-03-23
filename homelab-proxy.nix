{ pkgs, ... }:

let
  # Define a function to generate the Nginx configuration file
  generateNginxConfig = proxyAddr: {
    file = pkgs.writeText "nginx.conf" ''
      http {
        user nginx;
        worker_processes auto;
        error_log /var/log/nginx/error.log;

        events {
            worker_connections 1024 
        }

        server {
          listen 80;
          listen [::]:80;
          server_name ${proxyAddr};

          location /.well-known/acme-challenge {
            root /var/www/challenges;
          }

          location / {
            return 301 https://${proxyAddr}$request_uri;
          }
        }

        server {
          listen 443 ssl;
          server_name ${proxyAddr};

          ssl_certificate /etc/letsencrypt/live/${proxyAddr}/fullchain.pem;
          ssl_certificate_key /etc/letsencrypt/live/${proxyAddr}/privkey.pem;

          location / {
            root /var/www/html;
            index index.html;
          }

          location / {
            proxy_pass http://localhost:8000;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
          }
        }
      }
    '';

    # Automatically obtain and renew SSL certificate using Certbot
    # this only runs on Nix build (when Nginx should be down)
    certbotFlags = ''
        --webroot \
        --webroot-path /var/www/letsencrypt \
        --agree-tos \
        --non-interactive \
        --email mjmaurer777@gmail.com \
        -d ${proxyAddr} \
        --cert-name ${proxyAddr} \
        --deploy-hook "systemctl reload nginx"
    '';

    inNixShell = {
      nginxService = {
        Service = {
          ExecStart = "${pkgs.nginx}/bin/nginx -c ${config.environment.etc.nginx}/nginx.conf";
          ExecReload = "${pkgs.nginx}/bin/nginx -s reload";
          Restart = "always";
        };
      };
      certbotService = {
        Unit = {
          Description = "Certbot certificate registration for ${proxyAddr}";
          After = [ "nginx.service" ];
        };
        # Run once after starting nginx, and then weekly after
        Service = {
          Type = "oneshot";
          ExecStart = "certbot certonly ${certbotFlags}";
        };
        Timer = {
          OnCalendar = "weekly";
          RandomizedDelaySec = 5 * 60;
          Persistent = true;
        };
      };
    };
  };
in
{
  imports = [ ./common.nix ./common-linux.nix ];

  home.username = pkgs.lib.mkForce "ubuntu";

  home.packages = with pkgs; [
    home.packages
    nginx
    certbot
  ];

  programs.bash.sessionVariables = {
    MACHINE_NAME = "homelab-proxy";
  };

  # Generate the Nginx configuration file
  home.file."nginx.conf".text = generateNginxConfig "howell.haus";

  # Create the nginx user
  users.users = {
    "nginx" = {
      createHome = false;
      group = "nginx";
      home = "/var/lib/nginx";
      shell = "${pkgs.bash}/bin/bash";
      systemUser = true;
      uid = 102;
      gid = 102;
    };
  };
  
  # Create the nginx group
  users.groups = {
    "nginx" = {};
  };

  systemd.services = {
    "nginx.service" = systemd.mkEnable nginxService;
    "certbot.service" = systemd.mkEnable certbotService;
  }
}
