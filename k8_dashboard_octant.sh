#Author: RAVIKIRAN
#ocatant dashboard
#ps aux | grep kubectl
#kill -9 proxy
#kubenav mobile app(copy /etc/kubernetes/admin.conf to kubenav mobile application export kubeconfig path and you get access k8 cluster in mobile app) 

ipaddr=`ip addr show eth0 | grep "inet\b" | awk '{print $2}' | cut -d/ -f1`

wget -c https://github.com/vmware-tanzu/octant/releases/download/v0.24.0/octant_0.24.0_Linux-64bit.tar.gz

tar -xvf octant_0.24.0_Linux-64bit.tar.gz

cd octant_0.24.0_Linux-64bit 

mv octant /usr/local/bin

mkdir -p /usr/lib/systemd/system 

cd /usr/lib/systemd/system 

cat <<EOF | sudo tee octant.service
[Unit]
Description=octant
[Service]
Environment="HOME=/root"
Environment="OCTANT_ACCEPTED_HOSTS=$ipaddr"
Environment="KUBECONFIG=/root/.kube/config"
Environment="OCTANT_LISTENER_ADDR=0.0.0.0:8900"
Environment="OCTANT_DISABLE_OPEN_BROWSER=true"
Environment="PATH=/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin"
WorkingDirectory=/usr/local/bin/
ExecStart=/usr/local/bin/octant
Type=simple
Restart=on-failure
[Install]
WantedBy=multi-user.target
EOF

sudo chmod 755 -R /usr/lib/systemd/system/octant.service

sudo systemctl enable octant.service
sudo systemctl start octant.service
sudo systemctl status octant.service

 #http://<masterip:8900
