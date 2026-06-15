# Configuration du tier Middleware : Serveur d'application (Node.js)

# Génération du user_data avec templatefile
locals {
  user_data_template = templatefile("${path.module}/user_data.sh", {
    db_host     = var.db_host
    db_name     = var.db_name
    db_username = var.db_username
    db_password = var.db_password
  })
}

resource "ovh_cloud_project_instance" "app_server" {
  service_name = var.ovh_project_id
  name         = "${var.app_name}-middleware"
  flavor       = "b2-2"  # 1 vCPU, 2GB RAM
  region       = var.ovh_region
  
  # Image : Ubuntu 22.04 LTS
  image_id     = "ubuntu_22_04"
  
  # Stockage : 20GB
  volumes {
    name       = "${var.app_name}-middleware-volume"
    size       = 20
    type       = "classic"
    region     = var.ovh_region
  }
  
  # Réseau : Attaché au sous-réseau Middleware
  networks {
    network_id = var.vpc_id
    subnet_id  = var.middleware_subnet_id
    ip         = "192.168.20.10"  # IP statique dans le sous-réseau
  }
  
  # Groupe de sécurité
  security_groups = [var.middleware_sg_id]
  
  # Clé SSH pour l'accès (optionnel)
  ssh_key_id = var.ssh_key_id
  
  # Script de démarrage (user_data)
  user_data = local.user_data_template
  
  tags = ["middleware", "${var.app_name}"]
}

# IP publique pour le serveur (optionnel, pour le débogage)
resource "ovh_cloud_project_instance_public_ip" "app_server_ip" {
  service_name = var.ovh_project_id
  instance_id  = ovh_cloud_project_instance.app_server.id
  region       = var.ovh_region
}
