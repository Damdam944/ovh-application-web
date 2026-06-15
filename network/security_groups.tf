# Groupes de sécurité pour chaque tier

# Groupe de sécurité pour le Frontend (autorise HTTP/HTTPS depuis Internet)
resource "ovh_cloud_project_security_group" "frontend_sg" {
  service_name = var.ovh_project_id
  name         = "sg-frontend"
  description  = "Sécurité pour le tier Frontend (Nginx)"
}

resource "ovh_cloud_project_security_group_rule" "frontend_http" {
  service_name = var.ovh_project_id
  security_group_id = ovh_cloud_project_security_group.frontend_sg.id
  direction    = "ingress"
  protocol     = "tcp"
  port         = 80
  source       = "0.0.0.0/0"
  action       = "allow"
}

resource "ovh_cloud_project_security_group_rule" "frontend_https" {
  service_name = var.ovh_project_id
  security_group_id = ovh_cloud_project_security_group.frontend_sg.id
  direction    = "ingress"
  protocol     = "tcp"
  port         = 443
  source       = "0.0.0.0/0"
  action       = "allow"
}

# Autorise le trafic depuis le Frontend vers le Middleware (port 3000)
resource "ovh_cloud_project_security_group_rule" "frontend_to_middleware" {
  service_name = var.ovh_project_id
  security_group_id = ovh_cloud_project_security_group.frontend_sg.id
  direction    = "egress"
  protocol     = "tcp"
  port         = 3000
  destination  = ovh_cloud_project_security_group.middleware_sg.id
  action       = "allow"
}

# Groupe de sécurité pour le Middleware (autorise le trafic depuis le Frontend)
resource "ovh_cloud_project_security_group" "middleware_sg" {
  service_name = var.ovh_project_id
  name         = "sg-middleware"
  description  = "Sécurité pour le tier Middleware (Node.js)"
}

resource "ovh_cloud_project_security_group_rule" "middleware_from_frontend" {
  service_name = var.ovh_project_id
  security_group_id = ovh_cloud_project_security_group.middleware_sg.id
  direction    = "ingress"
  protocol     = "tcp"
  port         = 3000
  source       = ovh_cloud_project_security_group.frontend_sg.id
  action       = "allow"
}

# Autorise le trafic depuis le Middleware vers le Backend (PostgreSQL)
resource "ovh_cloud_project_security_group_rule" "middleware_to_backend" {
  service_name = var.ovh_project_id
  security_group_id = ovh_cloud_project_security_group.middleware_sg.id
  direction    = "egress"
  protocol     = "tcp"
  port         = 5432
  destination  = ovh_cloud_project_security_group.backend_sg.id
  action       = "allow"
}

# Groupe de sécurité pour le Backend (PostgreSQL)
resource "ovh_cloud_project_security_group" "backend_sg" {
  service_name = var.ovh_project_id
  name         = "sg-backend"
  description  = "Sécurité pour le tier Backend (PostgreSQL)"
}

resource "ovh_cloud_project_security_group_rule" "backend_from_middleware" {
  service_name = var.ovh_project_id
  security_group_id = ovh_cloud_project_security_group.backend_sg.id
  direction    = "ingress"
  protocol     = "tcp"
  port         = 5432
  source       = ovh_cloud_project_security_group.middleware_sg.id
  action       = "allow"
}

# Autorise le trafic SSH depuis une IP spécifique (optionnel, à désactiver en production)
resource "ovh_cloud_project_security_group_rule" "ssh_access" {
  count        = var.allow_ssh ? 1 : 0
  service_name = var.ovh_project_id
  security_group_id = ovh_cloud_project_security_group.frontend_sg.id
  direction    = "ingress"
  protocol     = "tcp"
  port         = 22
  source       = var.ssh_source_ip
  action       = "allow"
}
