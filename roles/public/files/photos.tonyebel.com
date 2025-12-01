server {
    listen 443 ssl;
    server_name photos.tonyebel.com;
    ssl_certificate /etc/letsencrypt/live/photos.tonyebel.com/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/photos.tonyebel.com/privkey.pem; # managed by Certbot

    # allow large file uploads
    client_max_body_size 50000M;

    # Set headers
    proxy_set_header Host              $http_host;
    proxy_set_header X-Real-IP         $remote_addr;
    proxy_set_header X-Forwarded-For   $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;

    # enable websockets: http://nginx.org/en/docs/http/websocket.html
    proxy_http_version 1.1;
    proxy_set_header   Upgrade    $http_upgrade;
    proxy_set_header   Connection "upgrade";
    proxy_redirect     off;

    # set timeout
    proxy_read_timeout 600s;
    proxy_send_timeout 600s;
    send_timeout       600s;

    location / {
        proxy_pass http://127.0.0.1:2283;
    }
}
