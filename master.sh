#! /bin/bash

#Get ip addr of network adapter eth0
ipaddr=`ip addr show eth0 | grep "inet\b" | awk '{print $2}' | cut -d/ -f1`


#kubeadm init = >This command initializes a Kubernetes control-plane node.
# --apiserver-advertise-address = The IP address the API Server will advertise it's listening on. If not set the default network interface will be used.
# --pod-network-cidr = Specify range of IP addresses for the pod network. If set, the control plane will automatically allocate CIDRs for every node.

kubeadm init --apiserver-advertise-address=$ipaddr --pod-network-cidr=192.168.0.0/16


echo "Please run this kubeadm join token in workernode0,1,2,so on to join to master......................"

kubeadm token create --print-join-command > /tmp/worker-join

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Install Calico Network Plugin for master node  to all node together

curl https://docs.projectcalico.org/manifests/calico.yaml -O

kubectl apply -f calico.yaml

=================================================
# Optional

# Install Metrics Server

kubectl apply -f https://raw.githubusercontent.com/scriptcamp/kubeadm-scripts/main/manifests/metrics-server.yaml

# Install Kubernetes Dashboard

kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0/aio/deploy/recommended.yaml

#--dry-run => Don't apply any changes; just it gives output  what it will done



