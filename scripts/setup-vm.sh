#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   bash scripts/setup-vm.sh
# Run on the VM (Ubuntu) once.

echo "[1/4] Update system packages"
sudo apt-get update -y


echo "[2/4] Install Docker + Compose"
sudo apt-get install -y ca-certificates curl gnupg lsb-release git
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update -y
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo usermod -aG docker "$USER"


echo "[3/4] Install K3s"
curl -sfL https://get.k3s.io | sh -


echo "[4/4] Verify installations"
docker --version
sudo k3s kubectl version --short
echo "VM setup complete. Reconnect your SSH session to apply docker group permissions."
