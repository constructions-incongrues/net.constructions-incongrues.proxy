#!/usr/bin/env make

# Commandes publiques

## Misc

help: ## Affichage de ce message d'aide
	@printf "\033[36m%s\033[0m (v%s)\n\n" $$(basename $$(pwd)) $$(git describe --tags --always)
	@echo "Commandes\n"
	@for MKFILE in $(MAKEFILE_LIST); do \
		grep -E '^[a-zA-Z0-9\._-]+:.*?## .*$$' $$MKFILE | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m  %-30s\033[0m  %s\n", $$1, $$2}'; \
	done

## Commands

clean: portainer-clean traefik-clean ## Arrêt et suppression des conteneurs

start: portainer-start traefik-start ## Démarrage des services

stop: portainer-stop traefik-stop ## Arrêt des services

## Services

### portainer
portainer-start:
	$(MAKE) -C services/portainer start

portainer-stop:
	$(MAKE) -C services/portainer stop

portainer-stop:
	$(MAKE) -C services/portainer clean

### traefik
traefik-start:
	$(MAKE) -C services/traefik start

traefik-stop:
	$(MAKE) -C services/traefik stop

traefik-clean:
	$(MAKE) -C services/traefik clean