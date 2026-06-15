# Outputs du module Frontend

output "web_server_public_ip" {
  description = "IP publique du serveur Frontend"
  value       = ovh_cloud_project_instance_public_ip.web_server_ip.ip
}

output "web_server_private_ip" {
  description = "IP privée du serveur Frontend"
  value       = "192.168.10.10"
}

output "web_server_id" {
  description = "ID de l'instance Frontend"
  value       = ovh_cloud_project_instance.web_server.id
}
