# Makefile pour gérer l'infrastructure Terraform OVH

.PHONY: init plan apply destroy output clean

# Variables (peuvent être surchargées)
TF_VARS_FILE ?= terraform.tfvars

init:
	@echo "Initialisation de Terraform..."
	terraform init

plan:
	@echo "Affichage du plan Terraform..."
	terraform plan -var-file=$(TF_VARS_FILE)

apply:
	@echo "Application de l'infrastructure..."
	terraform apply -var-file=$(TF_VARS_FILE) -auto-approve

destroy:
	@echo "Destruction de l'infrastructure..."
	terraform destroy -var-file=$(TF_VARS_FILE) -auto-approve

output:
	@echo "Affichage des outputs..."
	terraform output

clean:
	@echo "Nettoyage des fichiers Terraform..."
	rm -rf .terraform .terraform.lock.hcl terraform.tfstate terraform.tfstate.backup

# Cibles pour chaque module
plan-network:
	@echo "Plan pour le module réseau..."
	terraform plan -target=module.network -var-file=$(TF_VARS_FILE)

plan-backend:
	@echo "Plan pour le module backend..."
	terraform plan -target=module.backend -var-file=$(TF_VARS_FILE)

plan-middleware:
	@echo "Plan pour le module middleware..."
	terraform plan -target=module.middleware -var-file=$(TF_VARS_FILE)

plan-frontend:
	@echo "Plan pour le module frontend..."
	terraform plan -target=module.frontend -var-file=$(TF_VARS_FILE)

# Validation de la syntaxe
validate:
	@echo "Validation de la syntaxe Terraform..."
	terraform validate

# Formatage des fichiers
fmt:
	@echo "Formatage des fichiers Terraform..."
	terraform fmt
