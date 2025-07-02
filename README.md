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

<img width="702" alt="image" src="https://github.com/user-attachments/assets/7f9101b2-6660-401f-873b-0c6e0566cb3c" />


