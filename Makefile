#!/usr/bin/env make

export ENVIRONMENT := pastis-hosting.net
export COMPOSE_PROJECT_NAME := net-pastis-hosting-docker

# Import de la configuration environnementale
include ./etc/$(ENVIRONMENT)/.env
export $(shell sed 's/=.*//' ./etc/$(ENVIRONMENT)/.env)

# Commandes publiques

## Misc

help: ## Affichage de ce message d'aide
	@printf "\n\033[36m%s\033[0m \n\n" $$(basename $$(pwd))
	@echo "Commandes\n"
	@for MKFILE in $(MAKEFILE_LIST); do \
		grep -E '^[a-zA-Z0-9\._-]+:.*?## .*$$' $$MKFILE | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m  %-30s\033[0m  %s\n", $$1, $$2}'; \
	done

## Commands

clean: stop ## Suppression des conteneurs

purge: clean ## Supression des volumes

start: traefik-start portainer-start statping-start ## Démarrage des composants

stop: portainer-stop traefik-stop statping-stop ## Arrêt des composants

## Composants

### portainer
portainer-start: network
	$(MAKE) -C src/portainer start

portainer-stop:
	$(MAKE) -C src/portainer stop

portainer-clean: portainer-stop
	$(MAKE) -C src/portainer clean

portainer-purge: portainer-clean
	$(MAKE) -C src/portainer purge

### statping
statping-start: network
	$(MAKE) -C src/statping start

statping-stop:
	$(MAKE) -C src/statping stop

statping-clean: statping-stop
	$(MAKE) -C src/statping clean

statping-purge: statping-clean
	$(MAKE) -C src/statping purge

### traefik
traefik-start: network
	$(MAKE) -C src/traefik start

traefik-stop:
	$(MAKE) -C src/traefik stop

traefik-clean: traefik-stop network-remove
	$(MAKE) -C src/traefik clean

traefik-purge: traefik-stop network-clean
	$(MAKE) -C src/traefik purge

## Network

network:
	-docker network create \
		--driver=bridge \
		--attachable \
		--internal=false \
	$${COMPOSE_PROJECT_NAME}_public

network-remove:
	docker network rm $${COMPOSE_PROJECT_NAME}_public

## Remote

ssh: ## Connexion au serveur de production
	ssh -A debian@152.228.130.67
