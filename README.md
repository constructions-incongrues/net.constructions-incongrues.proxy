# net.constructions-incongrues.proxy

## Présentation

Ce projet permet de router du trafic vers des services exposés via de multiples `docker-compose.yml`.

## Installation

```sh
git clone git@github.com:constructions-incongrues/net.constructions-incongrues.proxy.git
```

## Services

- portainer
- traefik

Chaque service est situé dans un sous-répertoire dédié du dossier services.


### Configuration d'un projet

- Rajouter la définition de réseaux suivante au fichier `docker-compose.yml` du projet :

```yaml
networks:
  default:
    internal: true
  public:
    external:
      name: ${COMPOSE_PROJECT_NAME}_public
```

- Associer les services qui doivent être accessible publiquement au réseau partagé :

```yaml
services:
  # Service public
  nginx:
    image: nginx
    labels:
      - traefik.enable=true
      - traefik.docker.network=${COMPOSE_PROJECT_NAME}_public
    networks:
      - default
      - traefik

  # Service privé
  redis:
    image: redis
    networks:
      - default
```
