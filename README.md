	1) Create new VM. (Ubuntu 22.04)
	2) Install ssh and enable/start it.
	
Command: sudo apt-get -y install ssh -y ; sudo systemctl start ssh ; sudo systemctl enable ssh ; sudo systemctl status ssh
	
	3) Generate new Public/Private key on the VM:

Command: ssh-keygen -t rsa -b 4096
Command: cat ~/.ssh/id_rsa.pub
	
INFO: Distribute the public key within the Github account.

INFO: This allows us to git pull/push from my repositories.

	4) Execute the following commands with proper values:

Command(1): git config --global user.email "you@example.com"

Example: git config --global user.email "bogomilkovachev97@gmail.com"

Command(2): git config --global user.name "Your Name"

Example: git config --global user.name "BonganY23"


	5) Clone the "k3d" repository on the VM.
	
Command: git clone git@github.com:BonganY23/k3d.git

	5) Execute "prerequisites_k3d" script.
	6) Fork the "Simplifying-GitOps-with-FluxCD" repository in our own Github repository account
	7) Clone the "Simplifying-GitOps-with-FluxCD" repository in the VM.

Command: git clone git@github.com:BonganY23/Simplifying-GitOps-with-FluxCD.git

	8) Go to the following path "/Simplifying-GitOps-with-FluxCD/ch10/k3d-cluster-setup" and execute:

Command: task setup

	
	9) Create additional workers for our new cluster.
	 
	Command: k3d node create ch10-crossplane-worker   --cluster ch10-crossplane   --replicas 3   --role agent   --image rancher/k3s:v1.30.0-rc1-k3s1

	10) Execute the following command, so the cluster could be fully functional after restart.

Command: sed -i 's/0.0.0.0/127.0.0.1/g' ~/.kube/config

	11) Restart the cluster:

Command: k3d cluster stop ch10-crossplane ; k3d cluster start ch10-crossplane

----------------------------------------------------------------------------------------------------------------------------------------------------------

VirtualBox port forwarding (NAT):

We need only SSH 2222 to 22 in VirtualBox.

To access the GUI of Argo in the browser of the local PC, we need to create SSH tunnel.

Command: ssh -p2222 -L 8123:localhost:80 admin@localhost

8123 ==> This is random port which is currenlty not used!
80 ==> This is the port on which we managed to connect to Argo with Curl locally from the VM.

Example: 
root@bogomil:~/installation_steps/Simplifying-GitOps-with-FluxCD/Ingress# curl http://argocd.bogomil-test.com:80
<!doctype html><html lang="en"><head><meta charset="UTF-8"><title>Argo CD</title><base href="/"><meta name="viewport" content="width=device-width,initial-scale=1"><link rel="icon" type="image/png" href="assets/favicon/favicon-32x32.png" sizes="32x32"/><link rel="icon" type="image/png" href="assets/favicon/favicon-16x16.png" sizes="16x16"/><link href="assets/fonts.css" rel="stylesheet"><script defer="defer" src="main.3f69895b83faced35d2c.js"></script></head><body><noscript><p>Your browser does not support JavaScript. Please enable JavaScript to view the site. Alternatively, Argo CD can be used with the <a href="https://argoproj.github.io/argo-cd/cli_installation/">Argo CD CLI</a>.</p></noscript><div id="app"></div></body><script defer="defer" src="extensions.js"></script></html>root@bogomil:~/installation_steps/Simplifying-GitOps-with-FluxCD/Ingress# 



