#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   DOCKERHUB_USERNAME=linuxmint75 \
#   POSTGRES_PASSWORD=xxx \
#   IMAGE_TAG=latest \
#   bash scripts/deploy-k8s-vm.sh

: "${DOCKERHUB_USERNAME:?DOCKERHUB_USERNAME is required}"
: "${POSTGRES_PASSWORD:?POSTGRES_PASSWORD is required}"
: "${IMAGE_TAG:=latest}"

sudo k3s kubectl create namespace webapp --dry-run=client -o yaml | sudo k3s kubectl apply -f -

sudo k3s kubectl -n webapp create secret generic app-secrets \
  --from-literal=POSTGRES_PASSWORD="${POSTGRES_PASSWORD}" \
  --from-literal=DB_PASSWORD="${POSTGRES_PASSWORD}" \
  --dry-run=client -o yaml | sudo k3s kubectl apply -f -

sudo k3s kubectl apply -k k8s/

sudo k3s kubectl -n webapp set image deployment/backend backend=docker.io/${DOCKERHUB_USERNAME}/linuxmint75-backend:${IMAGE_TAG}
sudo k3s kubectl -n webapp set image deployment/frontend frontend=docker.io/${DOCKERHUB_USERNAME}/linuxmint75-frontend:${IMAGE_TAG}

sudo k3s kubectl -n webapp rollout status deployment/backend
sudo k3s kubectl -n webapp rollout status deployment/frontend

sudo k3s kubectl -n webapp get pods -o wide
sudo k3s kubectl -n webapp get svc
