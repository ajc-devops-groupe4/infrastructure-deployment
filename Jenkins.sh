#!/bin/bash

title="Install Jenkins"

echo "${title}"

# Update repository
sudo apt-get update -y

#Install Java SE
sudo apt-get install openjdk-11-jdk
java -version

# Import public key repository Jenkins
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null

# Dowload binary form Jenkins repository
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

# Update packages
sudo apt-get update -y

# Install Jenkins
sudo apt-get install jenkins -y

# Enable and start the Jenkins service
sudo systemctl enable --now jenkins
sudo systemctl status jenkins

isActive=$(sudo ufw status | grep "active")
Port=$(true &>/dev/null </dev/tcp/127.0.0.1/$PORT && echo open || echo closed)

if [ echo "$isActive" == "active" ]; then
	echo "Firewall is active"
	if [ echo "$Port" == "closed" ]; then
		sudo ufw allow 8080
		echo "Port 8080 is now open"
	else
		echo "Port 8080 is open"
	fi
else
	echo "ufw is not running"
	read -p "Do you want enable it? " -n 1 -r
	if [[ ! $REPLY =~ ^[Yy]$ ]]; then
		exit 1
	else
		sudo ufw allow 8080
		sudo systemctl enable --now ufw
		sudo ufw status
	fi
fi

curl -fsSL https://get.docker.com -o get-docker.sh
sudo chmod +x get-docker.sh
sudo sh get-docker.sh
sudo systemctl enable --now docker
sudo apt install docker-compose -y
usermod -aG docker jenkins

echo "here is your current admin password"
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
echo "Please open browser en try http://YOUR_IP:8080 to login and configure it"
