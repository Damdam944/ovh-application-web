# Sorties Terraform pour l'infrastructure 3-tiers

# --- Réseau ---
output "vpc_id" {
  description = "ID du VPC créé"
  value       = module.network.vpc_id
}

output "frontend_subnet_id" {
  description = "ID du sous-réseau Frontend"
  value       = module.network.frontend_subnet_id
}

output "middleware_subnet_id" {
  description = "ID du sous-réseau Middleware"
  value       = module.network.middleware_subnet_id
}

output "backend_subnet_id" {
  description = "ID du sous-réseau Backend"
  value       = module.network.backend_subnet_id
}

# --- Frontend ---
output "frontend_public_ip" {
  description = "IP publique du serveur Frontend (Nginx)"
  value       = module.frontend.web_server_public_ip
}

output "frontend_private_ip" {
  description = "IP privée du serveur Frontend"
  value       = module.frontend.web_server_private_ip
}

# --- Middleware ---
output "middleware_public_ip" {
  description = "IP publique du serveur Middleware (Node.js)"
  value       = module.middleware.app_server_public_ip
}

output "middleware_private_ip" {
  description = "IP privée du serveur Middleware"
  value       = module.middleware.app_server_private_ip
}

# --- Backend (Base de données) ---
output "db_host" {
  description = "Hôte de la base de données PostgreSQL"
  value       = module.backend.db_host
}

output "db_port" {
  description = "Port de la base de données PostgreSQL"
  value       = module.backend.db_port
}

output "db_name" {
  description = "Nom de la base de données"
  value       = module.backend.db_name
}

output "db_username" {
  description = "Nom d'utilisateur de la base de données"
  value       = module.backend.db_username
}

# --- URLs ---
output "app_url" {
  description = "URL de l'application (HTTP)"
  value       = "http://${module.frontend.web_server_public_ip}"
}

output "health_check_url" {
  description = "URL pour vérifier l'état de l'application"
  value       = "http://${module.frontend.web_server_public_ip}/health"
}

# --- Informations de connexion ---
output "ssh_frontend_command" {
  description = "Commande SSH pour se connecter au serveur Frontend"
  value       = "ssh ubuntu@${module.frontend.web_server_public_ip}"
}

output "ssh_middleware_command" {
  description = "Commande SSH pour se connecter au serveur Middleware"
  value       = "ssh ubuntu@${module.middleware.app_server_public_ip}"
}
