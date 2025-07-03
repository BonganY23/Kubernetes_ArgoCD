#!/bin/bash
set -euo pipefail

# Install docker
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get -y install ca-certificates curl
sudo apt update ; sudo apt install --reinstall ca-certificates ; sudo update-ca-certificates
export CURL_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
sudo apt -y install docker.io

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

# Install helm
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

# Install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/arm64/kubectl"
# Validate the binary (optional)
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/arm64/kubectl.sha256"
echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

rm -f get_helm.sh*
rm -f kubectl
rm -f kubectl.sha256

sh -c "$(curl --location https://taskfile.dev/install.sh)" -- -d -b /usr/local/bin/
curl -s https://fluxcd.io/install.sh | sudo bash

sudo apt -y install golang
echo 'export GOPATH=~/go' >> ~/.bashrc
source ~/.bashrc
mkdir -p "$GOPATH"

mkdir -p $GOPATH/src/github.com/getsops/sops/
git clone https://github.com/getsops/sops.git "$GOPATH/src/github.com/getsops/sops/"
cd "$GOPATH/src/github.com/getsops/sops/"
sudo apt-get -y install make
make install
apt install age

### Install argo command:
VERSION=$(curl -L -s https://raw.githubusercontent.com/argoproj/argo-cd/stable/VERSION)
curl -sSL -o argocd-linux-arm64 https://github.com/argoproj/argo-cd/releases/download/v$VERSION/argocd-linux-arm64
sudo install -m 555 argocd-linux-arm64 /usr/local/bin/argocd
rm argocd-linux-arm64
