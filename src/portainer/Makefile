#!/usr/bin/env make

# Import de la configuration environnementale
include ../../etc/$(ENVIRONMENT)/.env
export $(shell sed 's/=.*//' ../../etc/$(ENVIRONMENT)/.env)
include .env
export $(shell sed 's/=.*//' .env)

# Commandes publiques

## Misc

help: ## Affichage de ce message d'aide
	@printf "\033[36m%s\033[0m\n\n" $$(basename $$(pwd))
	@echo "Commands\n"
	@for MKFILE in $(MAKEFILE_LIST); do \
		grep -E '^[a-zA-Z0-9\._-]+:.*?## .*$$' $$MKFILE | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m  %-30s\033[0m  %s\n", $$1, $$2}'; \
	done
	@echo ""
	@echo "Endpoints"
	@echo
	@echo "  \033[36mPortainer\033[0m : http://portainer.$$SERVICES_DOMAIN"

## Contrôle des conteneurs

clean: stop # Suppression des conteneurs
	docker-compose -p $${COMPOSE_PROJECT_NAME}-portainer rm -f

purge: ## Suppression des volumes
	sudo rm -rf ../../var/portainer

start: ## Démarrage du service
	docker-compose -p $${COMPOSE_PROJECT_NAME}-portainer up --remove-orphans -d

stop: ## Arrêt du service
	docker-compose -p $${COMPOSE_PROJECT_NAME}-portainer stop
