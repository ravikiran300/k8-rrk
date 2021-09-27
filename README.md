# This repo consists:

kubeadm installation(production level k8s)

First run the script in all the nodes ./Nodes-common.sh(installs docker runtime and deps)

Next run master.sh only in master nodes (which bootstarps k8 cluster and install all its compenents)

copy a authentication file from master node /etc/kubernetes/admin.conf to worker nodes and run ./auth.sh script

if everything goes fine run:

kubectl get nodes -o wide(you will get master and nodes details which shows in ready state)






