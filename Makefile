#!/usr/bin/env make

# Import de la configuration environnementale
-include .env
export $(shell sed 's/=.*//' .env)

# Commandes publiques

## Misc

help: ## Affichage de ce message d'aide
	@printf "\033[36m%s\033[0m \n\n" $$(basename $$(pwd))
	@echo "Commandes\n"
	@for MKFILE in $(MAKEFILE_LIST); do \
		grep -E '^[a-zA-Z0-9\._-]+:.*?## .*$$' $$MKFILE | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m  %-30s\033[0m  %s\n", $$1, $$2}'; \
	done

## Commands

clean: stop ## tous les services : suppression des conteneurs

start: traefik portainer  ## tous les services : démarrage du service

stop: portainer-stop traefik-stop ## tous les services : arrêt du service

## Services

### portainer
portainer: ## portainer : démarrage du service
portainer-start: network
	$(MAKE) -C services/portainer start

portainer-stop: ## portainer : arrêt du service
	$(MAKE) -C services/portainer stop

portainer-clean: portainer-stop ## portainer : suppression des conteneurs
	$(MAKE) -C services/portainer clean

### traefik
traefik: ## traefik : démarrage du service
traefik-start: network
	$(MAKE) -C services/traefik start

traefik-stop: ## traefik : arrêt du service
	$(MAKE) -C services/traefik stop

traefik-clean: traefik-stop network-remove ## traefik : suppression des conteneurs
	$(MAKE) -C services/traefik clean

## Network

network: ## Création du réseau partagé
	-docker network create \
		--driver=bridge \
		--attachable \
		--internal=false \
	$${COMPOSE_PROJECT_NAME}_proxy

network-remove: ## Suppression du réseau partagé
	docker network rm $${COMPOSE_PROJECT_NAME}_proxy

## Remote

ssh: ## Connexion au serveur de production
	ssh -A debian@152.228.130.67

