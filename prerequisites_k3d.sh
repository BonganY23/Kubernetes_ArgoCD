#!/bin/bash
set -euo pipefail

# Detect OS and architecture
OS=$(uname | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)

case "$ARCH" in
  x86_64) ARCH="amd64" ;;
  aarch64 | arm64) ARCH="arm64" ;;
  *) echo "Unsupported architecture: $ARCH"; exit 1 ;;
esac

# Fix for Git Bash on Windows
if [[ "$OS" == "mingw"* || "$OS" == "msys"* ]]; then
  OS="windows"
fi

# Install docker
sudo apt-get update
sudo apt-get -y install ca-certificates curl
sudo apt update
sudo apt install --reinstall ca-certificates -y
sudo update-ca-certificates
export CURL_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
sudo apt -y install docker.io

# Add the repository to Apt sources
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
KUBE_VERSION=$(curl -L -s https://dl.k8s.io/release/stable.txt)

if [[ "$OS" == "windows" ]]; then
  curl -LO "https://dl.k8s.io/release/${KUBE_VERSION}/bin/windows/${ARCH}/kubectl.exe"
  echo "Downloaded kubectl.exe"
else
  curl -LO "https://dl.k8s.io/release/${KUBE_VERSION}/bin/${OS}/${ARCH}/kubectl"
  chmod +x kubectl
  sudo mv kubectl /usr/local/bin/kubectl
  echo "kubectl installed"
  # Validate (optional)
  curl -LO "https://dl.k8s.io/release/${KUBE_VERSION}/bin/${OS}/${ARCH}/kubectl.sha256"
  echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check
fi

# Cleanup
rm -f get_helm.sh* kubectl.sha256 || true

# Taskfile & Flux
sh -c "$(curl --location https://taskfile.dev/install.sh)" -- -d -b /usr/local/bin/
curl -s https://fluxcd.io/install.sh | sudo bash

# Install Golang and SOPS
sudo apt -y install golang
echo 'export GOPATH=~/go' >> ~/.bashrc
source ~/.bashrc
mkdir -p "$GOPATH"

mkdir -p "$GOPATH/src/github.com/getsops/sops/"
git clone https://github.com/getsops/sops.git "$GOPATH/src/github.com/getsops/sops/"
cd "$GOPATH/src/github.com/getsops/sops/"
sudo apt-get -y install make
make install
sudo apt install -y age

# Install ArgoCD CLI
ARGO_VERSION=$(curl -L -s https://raw.githubusercontent.com/argoproj/argo-cd/stable/VERSION)
curl -sSL -o argocd "https://github.com/argoproj/argo-cd/releases/download/v$ARGO_VERSION/argocd-${OS}-${ARCH}"
chmod +x argocd
sudo install -m 555 argocd /usr/local/bin/argocd
rm -f argocd
