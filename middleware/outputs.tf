# Outputs du module Middleware

output "app_server_public_ip" {
  description = "IP publique du serveur Middleware"
  value       = ovh_cloud_project_instance_public_ip.app_server_ip.ip
}

output "app_server_private_ip" {
  description = "IP privée du serveur Middleware"
  value       = "192.168.20.10"
}

output "app_server_id" {
  description = "ID de l'instance Middleware"
  value       = ovh_cloud_project_instance.app_server.id
}
