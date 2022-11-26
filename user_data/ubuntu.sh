#! /bin/bash
# https://docs.docker.com/engine/install/ubuntu/
sudo apt-get remove docker docker-engine docker.io containerd runc

sudo apt-get update
sudo apt-get -y install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get -y install docker-ce docker-ce-cli containerd.io docker-compose-plugin make

sudo groupadd docker
sudo usermod -aG docker ubuntu

# TBD: the below packages seems not to be installed during the process of userdata
# wasmedge
curl -sSf https://raw.githubusercontent.com/WasmEdge/WasmEdge/master/utils/install.sh | sudo bash -s -- -e all -p /usr/local

# containerd-shim-wasmedge
wget https://github.com/second-state/runwasi/releases/download/v0.3.3/containerd-shim-wasmedge-v1-v0.3.3-linux-amd64.tar.gz
tar -zxvf containerd-shim-wasmedge-v1-v0.3.3-linux-amd64.tar.gz
sudo mv containerd-shim-wasmedge-v1 /usr/local/bin/