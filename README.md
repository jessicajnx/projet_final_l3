# Projet DevOps - Deploiement automatise full stack

Ce projet repond aux exigences du TP:
- conteneurisation avec Docker
- orchestration multi-services avec Docker Compose
- deploiement Kubernetes sur VM cloud
- pipeline CI/CD automatique avec GitHub Actions
- gestion des variables d'environnement et des secrets
- documentation technique complete

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

## 5) Deploiement Kubernetes sur ta VM Azure

VM fournie:
- IP: `132.164.81.42`
- Connexion SSH:

```bash
ssh -i C:/Users/Jess/Downloads/efrei-jaunaux_key.pem azureuser@132.164.81.42
```

### 5.1 Installer les outils sur la VM

Depuis la VM:

```bash
bash scripts/setup-vm.sh
```

### 5.2 Deployer l'application dans K3s

Depuis la VM:

```bash
DOCKERHUB_USERNAME=linuxmint75 \
POSTGRES_PASSWORD='<mot_de_passe_db>' \
IMAGE_TAG=latest \
bash scripts/deploy-k8s-vm.sh
```

### 5.3 Verification Kubernetes

```bash
sudo k3s kubectl -n webapp get pods -o wide
sudo k3s kubectl -n webapp get svc
```

Application accessible depuis l'exterieur via:
- http://132.164.81.42:30080

## 5.bis) Demarrage rapide sur VM avec Docker Compose (acces public)

Si Kubernetes est instable sur une petite VM, utiliser Docker Compose sur la VM:

1. Se connecter en SSH a la VM
2. Aller dans le dossier du projet
3. Lancer:

```bash
sudo docker compose -f docker-compose.yml -f docker-compose.vm.yml up -d
```

Dans ce mode, le frontend est expose sur le port 80 de la VM:
- http://132.164.81.42
- http://132.164.81.42/health

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

Dans `Settings > Secrets and variables > Actions`:
- `DOCKERHUB_USERNAME` (ex: linuxmint75)
- `DOCKERHUB_TOKEN`
- `VM_HOST` (132.164.81.42)
- `VM_USER` (azureuser)
- `VM_SSH_KEY` (contenu de la cle privee PEM)
- `POSTGRES_PASSWORD`

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

