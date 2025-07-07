## Setup Instructions

### 1. Create new VM (Ubuntu 22.04)

Ubuntu 22.04 Image ISO: https://cdimage.ubuntu.com/releases/24.04/release/ubuntu-24.04.2-live-server-arm64.iso?_gl=1*1oaw01j*_gcl_au*NTYzMDA2MzU5LjE3NDQyOTQ5OTU.

### 2. Install ssh and enable/start it.

```bash
sudo apt-get update ; sudo apt-get -y install ssh -y ; sudo systemctl start ssh ; sudo systemctl enable ssh ; sudo systemctl status ssh
```

### 3. SSH to the VM:

```bash
ssh -p 2222 admin@127.0.0.1
```

### 4. Generate new Public/Private key on the VM
```bash
ssh-keygen -t rsa -b 4096
```
```bash
cat ~/.ssh/id_rsa.pub
```

### ℹ️ INFO: Distribute the public key within the Github account.

### ℹ️ INFO: This allows us to git pull/push from your repositories.

### 5. Configure Git with your credentials

git config --global user.email "you@example.com"

git config --global user.name "Your Name"

### Example:

```bash
git config --global user.email "bogomilkovachev97@gmail.com"
```
```bash
git config --global user.name "BonganY23"
```

### 6. Clone the "Kubernetes_ArgoCD" repository on the VM

```bash
git clone git@github.com:BonganY23/Kubernetes_ArgoCD.git
```

### 7. Execute prerequisites_k3d.sh script from the cloned repository.
### 8. Go to the following path and execute "setup task".

```bash
cd Deploy_Kubernetes_Cluster/k3d-cluster-setup
```
```bash
task setup
```
---------------------------------------------------------------------------------------------------------------------------------------------------

## VirtualBox port forwarding (NAT):

### We need only SSH 2222 to 22 in VirtualBox.

### To access the GUI of Argo in the browser of the local PC, we need to create SSH tunnel.

```bash
ssh -p2222 -L 8123:localhost:80 admin@localhost
```

8123 ==> This is random port which is currenlty not used! 

80 ==> This is the port on which we managed to connect to Argo with Curl locally from the VM!

### ℹ️ INFO: Execute the command from the local PC where the VM is hosted!

---------------------------------------------------------------------------------------------------------

### To access the GUI of Prometheus, we should create the following network confgiuration within VirtualBox:

Name: Prometheus

Protocol: TCP

Host IP: 127.0.0.1

Host Port: 9090

Guest IP: 10.0.2.15

Guest Port: 9090

---------------------------------------------------------------------------------------------------------------------------------------------------

To access ArgoCD from within the VM:

```bash
curl argocd.localhost:80
```

To access the ArgoCD GUI from the local PC (browser):
http://argocd.localhost:8123/

### To find the initial password for the "admin" user, please use the command below:
```bash
argocd admin initial-password -n argocd
```

---------------------------------------------------------------------------------------------------------------------------------------------------

To access the Prometheus GUI from the local PC (browser):
http://localhost:9090/query
