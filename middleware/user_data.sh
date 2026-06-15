#!/bin/bash
# Script de démarrage pour le serveur Middleware (Node.js)
# Les variables sont injectées via Terraform (templatefile)

set -e

echo "=== Mise à jour du système ==="
apt-get update -y
apt-get upgrade -y

echo "=== Installation des dépendances ==="
apt-get install -y curl git build-essential

echo "=== Installation de Node.js 18.x ==="
curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
apt-get install -y nodejs

echo "=== Vérification de Node.js ==="
node --version
npm --version

echo "=== Installation de PM2 (Process Manager) ==="
npm install -g pm2

echo "=== Création du répertoire de l'application ==="
mkdir -p /var/www/app
chown -R ubuntu:ubuntu /var/www/app

echo "=== Configuration de l'environnement ==="
cat > /var/www/app/.env << EOF
DB_HOST=${db_host}
DB_PORT=5432
DB_NAME=${db_name}
DB_USER=${db_username}
DB_PASSWORD=${db_password}
PORT=3000
EOF

chown ubuntu:ubuntu /var/www/app/.env

echo "=== Démarrage d'un serveur Node.js de test ==="
cat > /var/www/app/server.js << 'SERVEREOF'
const express = require('express');
const app = express();
const port = process.env.PORT || 3000;

app.get('/', (req, res) => {
  res.send('Hello from Middleware (Node.js) - OVH 3-Tier App');
});

app.get('/health', (req, res) => {
  res.json({ status: 'OK', tier: 'middleware' });
});

app.listen(port, () => {
  console.log(`Middleware server running on port ${port}`);
});
SERVEREOF

cd /var/www/app
npm init -y
npm install express

# Démarrer l'application avec PM2
pm2 start server.js --name "middleware-app"
pm2 save
pm2 startup

echo "=== Middleware prêt ! ==="
