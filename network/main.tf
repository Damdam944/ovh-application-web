# Configuration du réseau OVH Public Cloud
# Crée un VPC avec des sous-réseaux pour chaque tier

resource "ovh_cloud_project_network_private" "vpc" {
  service_name = var.ovh_project_id
  name         = "vpc-${var.app_name}"
  regions      = [var.ovh_region]
}

# Sous-réseau pour le tier Frontend
resource "ovh_cloud_project_network_private_subnet" "frontend_subnet" {
  service_name = var.ovh_project_id
  network_id   = ovh_cloud_project_network_private.vpc.id
  name         = "subnet-frontend"
  region       = var.ovh_region
  cidr         = "192.168.10.0/24"
  no_gateway   = false
}

# Sous-réseau pour le tier Middleware
resource "ovh_cloud_project_network_private_subnet" "middleware_subnet" {
  service_name = var.ovh_project_id
  network_id   = ovh_cloud_project_network_private.vpc.id
  name         = "subnet-middleware"
  region       = var.ovh_region
  cidr         = "192.168.20.0/24"
  no_gateway   = false
}

# Sous-réseau pour le tier Backend (DBaaS)
resource "ovh_cloud_project_network_private_subnet" "backend_subnet" {
  service_name = var.ovh_project_id
  network_id   = ovh_cloud_project_network_private.vpc.id
  name         = "subnet-backend"
  region       = var.ovh_region
  cidr         = "192.168.30.0/24"
  no_gateway   = false
}
