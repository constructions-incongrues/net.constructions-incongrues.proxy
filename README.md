# net.constructions-incongrues.traefik

## Présentation

Ce projet permet de router du trafic vers des services exposés via de multiples `docker-compose.yml`.

## Installation

```sh
git clone git@github.com:constructions-incongrues/net.constructions-incongrues.traefik.git
```

## Utilisation

### Démarrage

```sh
make start
```

Une fois démarré, le dashboard et l'API de Traefik sont accessibles à l'adresse <http://traefik.localhost>.

### Configuration

- Rajouter la définition de networks suivante au fichier `docker-compose.yml` du projet :

```yaml
networks:
  default:
    internal: true
  traefik:
    external:
      name: traefik
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
