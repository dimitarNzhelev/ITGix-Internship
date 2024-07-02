#!/bin/bash
sudo yum update
sudo yum install -y wget
sudo wget -O /etc/yum.repos.d/jenkins.repo \
https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
sudo yum upgrade
sudo yum makecache
sudo yum install -y fontconfig java-17-openjdk
sudo yum install -y jenkins
sudo systemctl start jenkins
sudo systemctl enable jenkins
sudo firewall-cmd --permanent --add-port=8080/tcp
sudo firewall-cmd --permanent --add-port=80/tcp
sudo firewall-cmd --reload
