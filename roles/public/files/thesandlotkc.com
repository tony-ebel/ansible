server {
  listen 443 ssl;
  server_name www.thesandlotkc.com;

  include /etc/letsencrypt/options-ssl-nginx.conf;
  ssl_certificate /etc/letsencrypt/live/thesandlotkc.com/fullchain.pem; # managed by Certbot
  ssl_certificate_key /etc/letsencrypt/live/thesandlotkc.com/privkey.pem; # managed by Certbot

  return 301 https://thesandlotkc.com;
}

server {
  listen 443 ssl;
  server_name thesandlotkc.com;

  include /etc/letsencrypt/options-ssl-nginx.conf;
  ssl_certificate /etc/letsencrypt/live/thesandlotkc.com/fullchain.pem; # managed by Certbot
  ssl_certificate_key /etc/letsencrypt/live/thesandlotkc.com/privkey.pem; # managed by Certbot

  return 307 https://sandlotkc.com;
}
