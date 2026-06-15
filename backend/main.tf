# Configuration du tier Backend : Base de données PostgreSQL (DBaaS)

resource "ovh_cloud_project_database" "postgresql" {
  service_name = var.ovh_project_id
  name         = "${var.app_name}-db"
  engine       = "postgresql"
  version      = "15"
  plan         = "db1-2"  # 1 vCPU, 2GB RAM, 50GB stockage
  region       = var.ovh_region
  
  # Configuration du réseau privé
  network_id   = var.vpc_id
  subnet_id    = var.backend_subnet_id
  
  # Mot de passe généré aléatoirement (stocké dans les outputs)
  password     = var.db_password
  
  # Sauvegardes automatiques
  backup_time  = "03:00"
  backup_retention = 7
  
  # Paramètres PostgreSQL
  options = {
    max_connections = 50
    shared_buffers  = "512MB"
  }
}

# Utilisateur de la base de données
resource "ovh_cloud_project_database_user" "app_user" {
  service_name = var.ovh_project_id
  database_id  = ovh_cloud_project_database.postgresql.id
  name         = var.db_username
  password     = var.db_password
  
  # Rôles PostgreSQL
  roles = ["createrole", "createdb"]
}

# Base de données par défaut
resource "ovh_cloud_project_database_database" "app_db" {
  service_name = var.ovh_project_id
  database_id  = ovh_cloud_project_database.postgresql.id
  name         = var.db_name
  owner        = ovh_cloud_project_database_user.app_user.name
}

# Association du groupe de sécurité au DBaaS
resource "ovh_cloud_project_database_security_group" "db_sg" {
  service_name = var.ovh_project_id
  database_id  = ovh_cloud_project_database.postgresql.id
  security_group_id = var.backend_sg_id
}

# Récupération de l'hôte de la base de données (pour les outputs)
locals {
  db_host = ovh_cloud_project_database.postgresql.host
  db_port = ovh_cloud_project_database.postgresql.port
}
