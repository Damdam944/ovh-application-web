# Variables du module réseau

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

variable "allow_ssh" {
  description = "Autoriser l'accès SSH"
  type        = bool
  default     = false
}

variable "ssh_source_ip" {
  description = "IP source autorisée pour SSH"
  type        = string
  default     = "0.0.0.0/0"
}
