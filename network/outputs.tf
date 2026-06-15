# Outputs du module réseau

output "vpc_id" {
  description = "ID du VPC"
  value       = ovh_cloud_project_network_private.vpc.id
}

output "frontend_subnet_id" {
  description = "ID du sous-réseau Frontend"
  value       = ovh_cloud_project_network_private_subnet.frontend_subnet.id
}

output "middleware_subnet_id" {
  description = "ID du sous-réseau Middleware"
  value       = ovh_cloud_project_network_private_subnet.middleware_subnet.id
}

output "backend_subnet_id" {
  description = "ID du sous-réseau Backend"
  value       = ovh_cloud_project_network_private_subnet.backend_subnet.id
}

output "frontend_sg_id" {
  description = "ID du groupe de sécurité Frontend"
  value       = ovh_cloud_project_security_group.frontend_sg.id
}

output "middleware_sg_id" {
  description = "ID du groupe de sécurité Middleware"
  value       = ovh_cloud_project_security_group.middleware_sg.id
}

output "backend_sg_id" {
  description = "ID du groupe de sécurité Backend"
  value       = ovh_cloud_project_security_group.backend_sg.id
}
