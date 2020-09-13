# Commandes publiques

## Misc

help: ## Affichage de ce message d'aide
	@printf "\033[36m%s\033[0m (v%s)\n\n" $$(basename $$(pwd)) $$(git describe --tags --always)
	@echo "Commandes\n"
	@for MKFILE in $(MAKEFILE_LIST); do \
		grep -E '^[a-zA-Z0-9\._-]+:.*?## .*$$' $$MKFILE | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m  %-30s\033[0m  %s\n", $$1, $$2}'; \
	done
	@echo ""
	@echo "Services"
	@echo
	@echo "  \033[36mTraefik\033[0m : http://traefik.localhost"

## Contrôle des conteneurs

start: ## Démarrage de Traefik
	-$(MAKE) network
	docker-compose up --remove-orphans -d

stop: ## Arrêt de Traefik
	docker-compose stop

# Commandes privées

network:
	docker network create \
		--driver=bridge \
		--attachable \
		--internal=false \
	traefik
