# Configuration du tier Frontend : Serveur Web (Nginx)

# Génération du user_data avec templatefile
locals {
  user_data_template = templatefile("${path.module}/user_data.sh", {
    middleware_ip = var.middleware_ip
  })
}

resource "ovh_cloud_project_instance" "web_server" {
  service_name = var.ovh_project_id
  name         = "${var.app_name}-frontend"
  flavor       = "b2-2"  # 1 vCPU, 2GB RAM
  region       = var.ovh_region
  
  # Image : Ubuntu 22.04 LTS
  image_id     = "ubuntu_22_04"
  
  # Stockage : 20GB
  volumes {
    name       = "${var.app_name}-frontend-volume"
    size       = 20
    type       = "classic"
    region     = var.ovh_region
  }
  
  # Réseau : Attaché au sous-réseau Frontend
  networks {
    network_id = var.vpc_id
    subnet_id  = var.frontend_subnet_id
    ip         = "192.168.10.10"  # IP statique dans le sous-réseau
  }
  
  # Groupe de sécurité
  security_groups = [var.frontend_sg_id]
  
  # Clé SSH pour l'accès (optionnel)
  ssh_key_id = var.ssh_key_id
  
  # Script de démarrage (user_data)
  user_data = local.user_data_template
  
  tags = ["frontend", "${var.app_name}"]
}

# IP publique pour le serveur Web
resource "ovh_cloud_project_instance_public_ip" "web_server_ip" {
  service_name = var.ovh_project_id
  instance_id  = ovh_cloud_project_instance.web_server.id
  region       = var.ovh_region
}
