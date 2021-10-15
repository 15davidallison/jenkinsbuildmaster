#!/bin/bash

# install and start jenkins
sudo yum install java-1.8.0 -y 
sudo yum remove java-1.7.0-openjdk
sudo amazon-linux-extras install epel -y
sudo yum install git -y
sudo yum update -y 
sudo yum install jenkins java-1.8.0-openjdk-devel
sudo yum -y install wget
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
sudo yum upgrade -y
sudo yum install jenkins -y
sudo systemctl start jenkins

# print out the admin password for jenkins
sudo su
echo "initialAdminPassword: "
cat /var/lib/jenkins/secrets/initialAdminPassword

# install terraform
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo yum -y install terraform