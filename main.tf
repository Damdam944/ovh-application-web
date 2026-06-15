# Configuration principale Terraform pour l'application 3-tiers chez OVH

terraform {
  required_version = ">= 1.0"
  
  required_providers {
    ovh = {
      source  = "ovh/ovh"
      version = "~> 0.40.0"
    }
  }
}

# Configuration du provider OVH
provider "ovh" {
  endpoint           = "ovh-eu"  # Pour l'Europe (GRA9, etc.)
  application_key    = var.ovh_api_key
  application_secret = var.ovh_api_secret
  consumer_key       = var.ovh_consumer_key
}

# Appel des modules

# Module Réseau (VPC, sous-réseaux, security groups)
module "network" {
  source = "./network"
  
  ovh_project_id = var.ovh_project_id
  app_name      = var.app_name
  ovh_region    = var.ovh_region
  allow_ssh     = var.allow_ssh
  ssh_source_ip = var.ssh_source_ip
}

# Module Backend (PostgreSQL DBaaS)
module "backend" {
  source = "./backend"
  
  ovh_project_id    = var.ovh_project_id
  app_name         = var.app_name
  ovh_region       = var.ovh_region
  vpc_id           = module.network.vpc_id
  backend_subnet_id = module.network.backend_subnet_id
  backend_sg_id    = module.network.backend_sg_id
  db_name          = var.db_name
  db_username      = var.db_username
  db_password      = var.db_password
}

# Module Middleware (Serveur d'application Node.js)
module "middleware" {
  source = "./middleware"
  
  ovh_project_id     = var.ovh_project_id
  app_name          = var.app_name
  ovh_region        = var.ovh_region
  vpc_id            = module.network.vpc_id
  middleware_subnet_id = module.network.middleware_subnet_id
  middleware_sg_id  = module.network.middleware_sg_id
  ssh_key_id        = var.ssh_key_id
  
  # Variables pour le user_data
  db_host          = module.backend.db_host
  db_name          = var.db_name
  db_username      = var.db_username
  db_password      = var.db_password
}

# Module Frontend (Serveur Web Nginx)
module "frontend" {
  source = "./frontend"
  
  ovh_project_id      = var.ovh_project_id
  app_name           = var.app_name
  ovh_region         = var.ovh_region
  vpc_id             = module.network.vpc_id
  frontend_subnet_id = module.network.frontend_subnet_id
  frontend_sg_id     = module.network.frontend_sg_id
  ssh_key_id         = var.ssh_key_id
  
  # IP du Middleware pour la configuration Nginx
  middleware_ip      = module.middleware.app_server_private_ip
}
