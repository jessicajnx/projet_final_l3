# Rapport de Projet DevOps

## 1) Contexte

Objectif: automatiser le deploiement d'une application web full stack pour reduire les erreurs manuelles et accelerer la mise en production.

## 2) Choix techniques

- Frontend: Nginx + page statique
- Backend: Node.js + Express
- Base de donnees: PostgreSQL
- Conteneurisation: Docker
- Orchestration locale: Docker Compose
- Orchestration cloud VM: Kubernetes (K3s)
- CI/CD: GitHub Actions

## 3) Etapes realisees

### 3.1 Conteneurisation

- Creation des Dockerfiles par service
- Build des images

Preuves (captures a inserer):
- Capture du build Docker backend
- Capture du build Docker frontend

### 3.2 Orchestration locale

- Mise en place de `docker-compose.yml`
- Demarrage des 3 services
- Verification de la communication frontend <-> backend <-> db

Preuves:
- Capture de `docker compose up`
- Capture de `docker compose ps`
- Capture de l'UI sur localhost:8081
- Capture de `/health`

### 3.3 Deploiement Kubernetes sur VM

- Installation Docker/Compose et K3s
- Application des manifests Kubernetes
- Exposition de l'application via NodePort

Preuves:
- Capture de `kubectl get pods -n webapp`
- Capture de `kubectl get svc -n webapp`
- Capture acces URL VM:30080

### 3.4 Pipeline CI/CD

- Configuration GitHub Actions
- Job tests
- Job build et push Docker Hub
- Job deploiement SSH sur VM

Preuves:
- Capture d'un run GitHub Actions reussi
- Capture des jobs (tests/build/deploy)
- Capture de la MAJ des pods Kubernetes apres push

## 4) Gestion des variables et secrets

- Variables d'environnement dans `.env`
- Secrets GitHub Actions pour Docker Hub, SSH et mot de passe DB
- Secret Kubernetes cree depuis le pipeline

Preuves:
- Capture ecran des noms de secrets GitHub (sans valeurs)

## 5) Difficultes rencontrees

- Difficultes:
	- stabilite de K3s sur une VM Azure avec faible memoire
- Erreurs:
	- `Unable to connect to the server: net/http: TLS handshake timeout`
	- erreurs de type `http2: client connection lost` dans les logs K3s
- Tentatives de correction:
	- ajout d'un swap de 2 Go
	- restart puis reinstallation de K3s en mode allege (sans traefik/servicelb/metrics-server)
	- application Kubernetes avec `--validate=false`
- Resultat final:
	- deploiement partiellement applique, mais instabilite persistante due aux ressources VM
	- recommandation: augmenter les ressources VM (minimum 2 vCPU / 4 Go RAM)

## 6) Si le projet n'est pas complet

Indiquer ici:
- Derniere etape atteinte
- Message d'erreur exact
- Analyse de la cause
- Correctifs testes

## 7) Conclusion

Resume des competences mobilisees:
- Docker / Compose
- Kubernetes
- CI/CD
- Cloud VM
- Documentation technique
