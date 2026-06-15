# Variables du module Backend (PostgreSQL)

variable "ovh_project_id" {
  description = "ID du projet OVH Public Cloud"
  type        = string
}

variable "app_name" {
  description = "Nom de l'application"
  type        = string
}

variable "ovh_region" {
  description = "Région OVH"
  type        = string
}

variable "vpc_id" {
  description = "ID du VPC"
  type        = string
}

variable "backend_subnet_id" {
  description = "ID du sous-réseau Backend"
  type        = string
}

variable "backend_sg_id" {
  description = "ID du groupe de sécurité Backend"
  type        = string
}

variable "db_name" {
  description = "Nom de la base de données"
  type        = string
}

variable "db_username" {
  description = "Nom d'utilisateur de la base de données"
  type        = string
}

variable "db_password" {
  description = "Mot de passe de la base de données"
  type        = string
  sensitive   = true
}
