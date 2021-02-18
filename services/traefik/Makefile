#!/usr/bin/env make

# Import de la configuration environnementale
include ../../.env
export $(shell sed 's/=.*//' .env)
include .env
export $(shell sed 's/=.*//' .env)

# Commandes publiques

## Misc

help: ## Affichage de ce message d'aide
	@printf "\033[36m%s\033[0m \n\n" $$(basename $$(pwd))
	@echo "Commandes\n"
	@for MKFILE in $(MAKEFILE_LIST); do \
		grep -E '^[a-zA-Z0-9\._-]+:.*?## .*$$' $$MKFILE | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m  %-30s\033[0m  %s\n", $$1, $$2}'; \
	done
	@echo ""
	@echo "Services"
	@echo
	@echo "  \033[36mTraefik\033[0m : https://$$SERVICE.$$DOMAIN"

## Contrôle des conteneurs

clean: stop
	docker-compose rm -f

start: ## Démarrage
	docker-compose up --remove-orphans -d

stop: ## Arrêt
	docker-compose stop

