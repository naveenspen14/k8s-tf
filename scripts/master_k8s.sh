#!/bin/bash

# if OS is Ubuntu
if [ -f /etc/lsb-release ]; then
	sudo hostnamectl set-hostname --static "$(curl -s http://169.254.169.254/latest/meta-data/local-hostname)"

	sudo swapoff -a
	sudo sed -i.bak -r 's/(.+ swap .+)/#\1/' /etc/fstab
        sudo modprobe br_netfilter

	sudo apt-get update && sudo apt-get install -y apt-transport-https curl
	sudo curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF

	sudo apt-get update
	sudo apt-get install -y kubelet=1.21.1-00 kubeadm=1.21.1-00 kubectl=1.21.1-00
	sudo apt-mark hold kubelet kubeadm kubectl

        sudo apt install python -y
	sudo apt install docker.io -y
        sudo apt install git -y

cat > /home/ubuntu/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF

        sudo mv /home/ubuntu/daemon.json /etc/docker/ 
	sudo systemctl restart docker
	sudo systemctl enable docker
	#sed -i "$ s/$/ --cloud-provider=aws/" /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
        if [ -e /etc/systemd/system/kubelet.service.d/10-kubeadm.conf ]; then
	   sudo sed -i "$ s/$/ --cloud-provider=aws --node-ip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`/" /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
	   sudo systemctl daemon-reload
           sudo systemctl restart kubelet
           sudo systemctl enable kubelet

        fi

fi
 
# Start/Initiate Kubernetes Master
sleep 30
sudo kubeadm init --service-cidr=192.168.0.0/16

# Copy admin.conf to a proper location to be able to use kubectl
mkdir "$HOME/.kube"
yes | sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown ubuntu:ubuntu $HOME/.kube/config

# Download and Install CNI file: calico.yaml 
curl https://docs.projectcalico.org/manifests/calico.yaml -O 
kubectl apply -f calico.yaml
sleep 15

# if OS is CentOS and RHEL
if [ -f /etc/redhat-release ]; then
  sudo yum update
fi

