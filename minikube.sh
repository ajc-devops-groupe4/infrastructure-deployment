#!/bin/bash

title = "Install minikube"

echo "${Install minikube}"

curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube_latest_amd64.deb
sudo dpkg -i minikube_latest_amd64.deb
sudo apt-get install ca-certificates curl gnupg lsb-release

echo "Removing the old installation Docker"
sudo apt-get remove docker docker-engine docker.io containerd runc

"Import the public key of the official repository Docker"
sudo mkdir -p /etc/apt/keyrings

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "Update system and install Docker"
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin

echo "start and enable the Docker service"
sudo systemctl enable --now docker

echo "Add user to the current user to the Docker group"
sudo usermod -aG docker $USER

echo "Please leave the session and reconnect
exec sudo -iu $USER

echo "Install minikube
minikube start --driver=docker

echo "Try the Minikube functionnality"
minikube kubectl -- get pods -A
