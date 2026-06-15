# Variables pour l'infrastructure 3-tiers OVH

# --- OVH Cloud Credentials ---
variable "ovh_api_key" {
  description = "Clé API OVH (Application Key)"
  type        = string
  sensitive   = true
}

variable "ovh_api_secret" {
  description = "Secret API OVH (Application Secret)"
  type        = string
  sensitive   = true
}

variable "ovh_consumer_key" {
  description = "Consumer Key OVH"
  type        = string
  sensitive   = true
}

variable "ovh_project_id" {
  description = "ID du projet OVH Public Cloud"
  type        = string
}

# --- Configuration Générale ---
variable "app_name" {
  description = "Nom de l'application (utilisé pour nommer les ressources)"
  type        = string
  default     = "ovh-3tier-app"
}

variable "ovh_region" {
  description = "Région OVH (ex: GRA9 pour Gravelines, BHS5 pour Beauharnois)"
  type        = string
  default     = "GRA9"
}

# --- Configuration SSH (optionnel) ---
variable "ssh_key_id" {
  description = "ID de la clé SSH dans OVH pour l'accès aux instances"
  type        = string
  default     = null
}

variable "allow_ssh" {
  description = "Autoriser l'accès SSH depuis une IP spécifique"
  type        = bool
  default     = false
}

variable "ssh_source_ip" {
  description = "IP source autorisée pour SSH (ex: 123.123.123.123/32)"
  type        = string
  default     = "0.0.0.0/0"
}

# --- Configuration Base de Données ---
variable "db_name" {
  description = "Nom de la base de données"
  type        = string
  default     = "app_db"
}

variable "db_username" {
  description = "Nom d'utilisateur de la base de données"
  type        = string
  default     = "app_user"
}

variable "db_password" {
  description = "Mot de passe de la base de données"
  type        = string
  sensitive   = true
  default     = "ChangeMeInProduction123!"
}
