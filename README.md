# Projet DevOps - Deploiement automatise full stack

## 1) Architecture

Services:
- frontend: Nginx qui sert une page web et proxy les routes `/health` et `/api/*` vers le backend
- backend: API Node.js/Express avec endpoint `/health` et `/api/message`
- db: PostgreSQL utilise par le backend

Communication:
- frontend -> backend via reseau Docker/Kubernetes
- backend -> db via variables d'environnement

## 2) Prerequis

En local:
- Docker
- Docker Compose

Sur VM (Azure):
- Docker + Docker Compose plugin
- K3s (ou Minikube)

## 3) Lancer en local avec Docker Compose

1. Copier les variables d'environnement:

```bash
cp .env.example .env
```

2. Construire et demarrer les conteneurs:

```bash
docker compose up --build -d
```

3. Verifier:
- Frontend: http://localhost:8081
- Health backend: http://localhost:3000/health
- Message backend: http://localhost:3000/api/message

4. Logs:

```bash
docker compose logs -f
```

5. Arret:

```bash
docker compose down
```

## 4) Dockerfiles et Compose

- Un Dockerfile par service:
  - `backend/Dockerfile` (multi-stage build)
  - `frontend/Dockerfile`
- Orchestration:
  - `docker-compose.yml`

## 5) Application en production

L'application est deploiee et accessible en ligne sur:

**URL publique:** http://132.164.81.42

Endpoints disponibles:
- `/health` - statut de sante de l'application
- `/api/message` - message depuis l'API

Pour consulter le statut, visiter: http://132.164.81.42/health

## 6) Pipeline CI/CD (GitHub Actions)

Fichier pipeline:
- `.github/workflows/ci-cd.yml`

Flux implemente:

`git push`  
-> CI/CD  
-> 1) installation des dependances  
-> 2) tests  
-> 3) build Docker  
-> 4) push images Docker Hub  
-> 5) deploiement sur VM en SSH  
-> 6) mise a jour Kubernetes

### Comportement
- automatique sur push vers `main`
- echec si tests echouent
- deploiement sans action manuelle si CI valide

### Secrets GitHub a configurer

Dans `Settings > Secrets and variables > Actions`, ajouter les secrets suivants:
- `DOCKERHUB_USERNAME` - identifiant Docker Hub
- `DOCKERHUB_TOKEN` - token d'authentification Docker Hub
- `VM_HOST` - adresse IP/domaine de la VM
- `VM_USER` - utilisateur SSH
- `VM_SSH_KEY` - cle privee SSH
- `POSTGRES_PASSWORD` - mot de passe base de donnees

## 7) Variables d'environnement et secrets

- Variables locales versionnees: `.env.example`
- Secret non versionne: `.env` (ignore via `.gitignore`)
- Secret Kubernetes cree dynamiquement dans le pipeline (pas de secret en clair dans le code)

## 8) Endpoints requis

- `/health` (backend)
- `/api/message` (backend)

Le frontend affiche le statut de `/health` et le message API.

## 9) Difficultes rencontrees (a renseigner)

Exemple de formulation attendue:
- Etape bloquante:
- Erreur observee:
- Tentatives de correction:
- Resolution:

Retour d'experience reel sur la VM Azure fournie:
- Etape bloquante: stabilite de l'API Kubernetes (K3s)
- Erreur observee: `Unable to connect to the server: net/http: TLS handshake timeout`
- Cause probable: VM tres contrainte (environ 847 MiB RAM), sans swap au depart
- Tentatives de correction effectuees:
  - installation Docker + K3s validee
  - ajout d'un swap 2GiB
  - reinstallation K3s en mode allege (`--disable traefik --disable servicelb --disable metrics-server`)
  - application des manifests avec `--validate=false`
- Resultat: cluster parfois utilisable, mais instable par intermittence sur cette taille de VM

Recommandation pour obtenir un deploiement Kubernetes stable:
- passer la VM a 2 vCPU / 4 Go RAM minimum (idealement 4 Go+)

## 10) Contenu du depot

Le depot contient:
- code source frontend + backend
- Dockerfiles
- `docker-compose.yml`
- manifests Kubernetes
- pipeline CI/CD
- scripts VM/deploiement
- README et rapport

## 11) Rapport de projet

Completer le fichier `REPORT.md` avec:
- contexte
- etapes realisees
- captures d'ecran de preuve
- erreurs et corrections

