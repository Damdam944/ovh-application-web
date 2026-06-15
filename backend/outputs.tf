# Outputs du module Backend (PostgreSQL)

output "db_host" {
  description = "Hôte de la base de données"
  value       = ovh_cloud_project_database.postgresql.host
}

output "db_port" {
  description = "Port de la base de données"
  value       = ovh_cloud_project_database.postgresql.port
}

output "db_name" {
  description = "Nom de la base de données"
  value       = ovh_cloud_project_database_database.app_db.name
}

output "db_username" {
  description = "Nom d'utilisateur de la base de données"
  value       = ovh_cloud_project_database_user.app_user.name
}

output "db_id" {
  description = "ID de l'instance de base de données"
  value       = ovh_cloud_project_database.postgresql.id
}
