server {
  listen 443 ssl;
  server_name cooperjosh.com;

  include /etc/letsencrypt/options-ssl-nginx.conf;

  ssl_certificate /etc/letsencrypt/live/cooperjosh.com/fullchain.pem; # managed by Certbot
  ssl_certificate_key /etc/letsencrypt/live/cooperjosh.com/privkey.pem; # managed by Certbot

  root /var/www/cooperjosh;

  location / {
    try_files $uri $uri/ =404;
  }
}
