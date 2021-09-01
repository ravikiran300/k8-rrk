#! /bin/bash


#The Kubernetes scheduler determines the best available node on which to deploy newly created pods.
#If memory swapping is allowed to occur on a host system, this can lead to performance and stability issues within Kubernetes.

# disable swap 
sudo swapoff -a

# keeps the swaf off during reboot
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

#=======================================================================================================
#Update the apt package index and install packages to allow apt to use a repository over HTTPS

sudo apt-get update -y

 sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

#Add Docker’s official GPG key:
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update -y

#Install docker pacakage
sudo apt-get  install -y docker-ce docker-ce-cli containerd.io 


sudo mkdir /etc/docker
cat <<EOF | sudo tee /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF

#Letting iptables see bridged traffic
sudo modprobe br_netfilter

cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

sudo sysctl --system

sudo systemctl enable docker
sudo systemctl daemon-reload
sudo systemctl restart docker

echo "Docker Runtime Configured Successfully"

#==================================================================================

#kubeadm: the command to bootstrap the cluster.
#kubelet: the component that runs on all of the machines in your cluster and does things like starting pods and containers.
#kubectl: the command line util to talk to your cluster

sudo apt-get update -y 
sudo apt-get install -y apt-transport-https ca-certificates curl
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg

echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt-get update -y

#sudo apt-get install -y kubelet=$KUBERNETES_VERSION kubectl=$KUBERNETES_VERSION kubeadm=$KUBERNETES_VERSION

#install binaries
sudo apt-get install -y kubelet kubeadm kubectl

#apt-mark will mark or unmark a software package as being automatically installed and it is used with option hold
sudo apt-mark hold kubelet kubeadm kubectl



#echo "Please run this kubeadm join token in workernode0,1,2,so on to join to master......................"

#kubeadm token create --print-join-command


