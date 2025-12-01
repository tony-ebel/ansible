server {
  listen 80 default_server;
  listen [::]:80 default_server;
  server_name _;

  return 301 https://$host$request_uri;
}


server {
  listen 443 ssl;
  server_name tonyebel.com;

  include /etc/letsencrypt/options-ssl-nginx.conf;

  ssl_certificate /etc/letsencrypt/live/tonyebel.com/fullchain.pem; # managed by Certbot
  ssl_certificate_key /etc/letsencrypt/live/tonyebel.com/privkey.pem; # managed by Certbot


  location / {
    proxy_pass http://127.0.0.1:8500/;
  }
}
