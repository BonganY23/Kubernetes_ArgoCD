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
	
Command: git clone --branch Modified_by_me_newest --single-branch git@github.com:BonganY23/Simplifying-GitOps-with-FluxCD.git

6) Execute "prerequisites_k3d" script from the clonned repository.

7) Go to the following path "/Simplifying-GitOps-with-FluxCD/ch10/k3d-cluster-setup" and execute:

Command: task setup

8) Create additional workers for our new cluster.
	 
Command: k3d node create ch10-crossplane-worker   --cluster ch10-crossplane   --replicas 3   --role agent   --image rancher/k3s:v1.30.0-rc1-k3s1

9) Execute the following command, so the cluster could be fully functional after restart.

Command: sed -i 's/0.0.0.0/127.0.0.1/g' ~/.kube/config


----------------------------------------------------------------------------------------------------------------------------------------------------------

VirtualBox port forwarding (NAT):

We need only SSH 2222 to 22 in VirtualBox.

To access the GUI of Argo in the browser of the local PC, we need to create SSH tunnel.

Command: ssh -p2222 -L 8123:localhost:80 admin@localhost

8123 ==> This is random port which is currenlty not used!
80 ==> This is the port on which we managed to connect to Argo with Curl locally from the VM.

Example: 
curl argocd.localhost:80

The URL from which we can access the Argo from our local PC is as follow:
http://argocd.localhost:8123/

----------------------------------------------------------------------------------------------------------------------------------------------------------



