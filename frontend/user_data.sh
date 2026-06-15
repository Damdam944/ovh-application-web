#!/bin/bash
# Script de démarrage pour le serveur Frontend (Nginx)
# Les variables sont injectées via Terraform (templatefile)

set -e

echo "=== Mise à jour du système ==="
apt-get update -y
apt-get upgrade -y

echo "=== Installation de Nginx ==="
apt-get install -y nginx

echo "=== Configuration de Nginx comme reverse proxy ==="
cat > /etc/nginx/sites-available/app << EOF
server {
    listen 80;
    server_name _;

    location / {
        proxy_pass http://${middleware_ip}:3000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }

    location /health {
        proxy_pass http://${middleware_ip}:3000/health;
        proxy_set_header Host \$host;
    }
}
EOF

# Activer la configuration
ln -sf /etc/nginx/sites-available/app /etc/nginx/sites-enabled/app
rm -f /etc/nginx/sites-enabled/default

echo "=== Test de la configuration Nginx ==="
nginx -t

echo "=== Redémarrage de Nginx ==="
systemctl restart nginx
systemctl enable nginx

echo "=== Installation de certbot pour HTTPS (optionnel) ==="
apt-get install -y certbot python3-certbot-nginx

echo "=== Frontend prêt ! ==="
