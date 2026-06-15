# Variables du module Frontend

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

variable "frontend_subnet_id" {
  description = "ID du sous-réseau Frontend"
  type        = string
}

variable "frontend_sg_id" {
  description = "ID du groupe de sécurité Frontend"
  type        = string
}

variable "ssh_key_id" {
  description = "ID de la clé SSH"
  type        = string
  default     = null
}

variable "middleware_ip" {
  description = "IP privée du serveur Middleware (pour Nginx)"
  type        = string
}
