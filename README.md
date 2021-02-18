# net.constructions-incongrues.proxy

## Présentation

Ce projet permet de router du trafic vers des services exposés via de multiples `docker-compose.yml`.

## Installation

```sh
git clone git@github.com:constructions-incongrues/net.constructions-incongrues.proxy.git
```

## Services

Chaque service est situé dans un sous-répertoire dédié du dossier services.

### portainer

#### Démarrage

```sh
make start
```

Une fois démarré, Portainer est accessible à l'adresse <http://portainer.proxy.localhost>.

### traefik

#### Démarrage

```sh
make start
```

Une fois démarré, le dashboard et l'API de Traefik sont accessibles à l'adresse <http://traefik.proxy.localhost>.

### Configuration d'un projet

- Rajouter la définition de networks suivante au fichier `docker-compose.yml` du projet :

```yaml
networks:
  default:
    internal: true
  traefik:
    external:
      name: netconstructions-incongruesproxy_traefik
```

- Associer les services qui doivent être accessible publiquement au réseau `traefik` :

```yaml
services:
  # Service public
  nginx:
    image: nginx
    labels:
      - traefik.enable=true
      - traefik.docker.network=traefik
    networks:
      - default
      - traefik

  # Service privé
  redis:
    image: redis
    networks:
      - default
```
