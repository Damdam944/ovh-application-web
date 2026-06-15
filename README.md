# OVH Application Web - Infrastructure 3-Tiers avec Terraform

Ce dépôt contient une configuration Terraform pour déployer une **application web 3-tiers** sur **OVH Public Cloud**.

## 🏗️ Architecture

L'infrastructure suit une architecture classique en 3 tiers :

```
┌─────────────────────────────────────────────────────────────────┐
│                        INTERNET                                    │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                    TIER 1 : FRONTEND (Nginx)                        │
│  - Instance OVH (1 vCPU, 2GB RAM, 20GB stockage)                   │
│  - IP publique accessible depuis Internet                         │
│  - Reverse proxy vers le Middleware (port 3000)                   │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                   TIER 2 : MIDDLEWARE (Node.js)                     │
│  - Instance OVH (1 vCPU, 2GB RAM, 20GB stockage)                   │
│  - Serveur d'application Node.js avec Express                     │
│  - Se connecte à la base de données PostgreSQL                     │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                    TIER 3 : BACKEND (PostgreSQL)                    │
│  - OVH DBaaS PostgreSQL 15 (1 vCPU, 2GB RAM, 50GB stockage)        │
│  - Base de données gérée avec sauvegardes automatiques            │
└─────────────────────────────────────────────────────────────────┘
```

### Réseau
- **VPC** : Réseau privé dédié pour isoler les 3 tiers
- **Sous-réseaux** :
  - `192.168.10.0/24` pour le Frontend
  - `192.168.20.0/24` pour le Middleware
  - `192.168.30.0/24` pour le Backend
- **Groupes de sécurité** :
  - Frontend : Autorise HTTP/HTTPS (80/443) depuis Internet
  - Middleware : Autorise le trafic depuis le Frontend (port 3000)
  - Backend : Autorise le trafic depuis le Middleware (port 5432)

## 📁 Structure du projet

```
ovh-application-web/
├── main.tf               # Configuration principale et modules
├── variables.tf          # Variables globaless
├── outputs.tf            # Sorties Terraform
├── terraform.tfvars.example  # Exemple de variables
├── Makefile              # Commandes utiles
├── .gitignore            # Fichiers à ignorer
├── backend/
│   ├── main.tf           # Base de données PostgreSQL DBaaS
│   ├── variables.tf      # Variables du module
│   └── outputs.tf        # Sorties du module
├── middleware/
│   ├── main.tf           # Serveur Node.js
│   ├── user_data.sh      # Script de démarrage
│   ├── variables.tf      # Variables du module
│   └── outputs.tf        # Sorties du module
├── frontend/
│   ├── main.tf           # Serveur Nginx
│   ├── user_data.sh      # Script de démarrage
│   ├── variables.tf      # Variables du module
│   └── outputs.tf        # Sorties du module
└── network/
    ├── main.tf           # VPC et sous-réseaux
    ├── security_groups.tf # Groupes de sécurité
    ├── variables.tf      # Variables du module
    └── outputs.tf        # Sorties du module
```

## 🚀 Déploiement

### Prérequis
1. **Compte OVH** avec accès à **Public Cloud**
2. **Clés API OVH** :
   - [Créer une application API](https://eu.api.ovh.com/)
   - Récupérer : `Application Key`, `Application Secret`, `Consumer Key`
3. **Terraform** installé (`>= 1.0`)
4. **Projet OVH Public Cloud** créé

### Étapes

1. **Cloner le dépôt** :
   ```bash
   git clone https://github.com/Damdam944/ovh-application-web.git
   cd ovh-application-web
   ```

2. **Configurer les variables** :
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   # Éditer terraform.tfvars avec vos informations OVH
   ```

3. **Initialiser Terraform** :
   ```bash
   terraform init
   ```

4. **Vérifier le plan** :
   ```bash
   terraform plan
   ```

5. **Déployer l'infrastructure** :
   ```bash
   terraform apply
   ```

6. **Accéder à l'application** :
   - L'URL sera affichée dans les outputs : `app_url`
   - Exemple : `http://123.123.123.123`

### Utilisation avec Make

```bash
# Initialisation
make init

# Voir le plan
make plan

# Déployer
make apply

# Détruire (attention !)
make destroy

# Valider la syntaxe
make validate
```

## 🔧 Configuration

### Variables principales (`terraform.tfvars`)

| Variable | Description | Exemple |
|----------|-------------|---------|
| `ovh_api_key` | Clé API OVH | `"abc123..."` |
| `ovh_api_secret` | Secret API OVH | `"def456..."` |
| `ovh_consumer_key` | Consumer Key OVH | `"ghi789..."` |
| `ovh_project_id` | ID du projet OVH | `"1234567890abcdef"` |
| `app_name` | Nom de l'application | `"mon-app"` |
| `ovh_region` | Région OVH | `"GRA9"` (Gravelines) |
| `db_password` | Mot de passe DB | `"UnMotDePasseSecurise123!"` |

### Régions disponibles
- `GRA9` : Gravelines, France (recommandé pour l'Europe)
- `BHS5` : Beauharnois, Canada
- `DE1` : Allemagne

## 📊 Outputs

Après déploiement, Terraform affichera :

| Output | Description |
|--------|-------------|
| `app_url` | URL de l'application |
| `frontend_public_ip` | IP publique du Frontend |
| `middleware_public_ip` | IP publique du Middleware |
| `db_host` | Hôte de la base de données |
| `ssh_frontend_command` | Commande SSH pour le Frontend |
| `ssh_middleware_command` | Commande SSH pour le Middleware |

## 🔒 Sécurité

- **Ne jamais commiter** `terraform.tfvars` (contient des secrets)
- Utiliser des **groupes de sécurité** pour limiter l'accès
- Désactiver `allow_ssh` en production ou restreindre `ssh_source_ip`
- Changer le mot de passe de la base de données après déploiement

## 🧹 Nettoyage

Pour détruire toute l'infrastructure :

```bash
terraform destroy
```

⚠️ **Attention** : Cela supprimera toutes les ressources créées (instances, base de données, réseau).

## 📚 Ressources

- [Documentation OVH Public Cloud](https://docs.ovh.com/fr/public-cloud/)
- [Provider Terraform OVH](https://registry.terraform.io/providers/ovh/ovh/latest/docs)
- [API OVH](https://api.ovh.com/)

## 🤝 Contribution

Les contributions sont les bienvenues ! Ouvrez une PR ou un issue pour toute suggestion.

## 📄 Licence

MIT
