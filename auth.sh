mkdir -p $HOME/.kube
sudo cp -i /tmp/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
