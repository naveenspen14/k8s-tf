#!/bin/bash

# if OS is Ubuntu
if [ -f /etc/lsb-release ]; then

	hostnamectl set-hostname --static "$(curl -s http://169.254.169.254/latest/meta-data/local-hostname)"
	sudo apt-get update && sudo apt-get install nginx 
	systemctl enable nginx
	systemctl start nginx

fi

# if OS is rhel or centos
if [ -f /etc/redhat-release ]; then
  yum -y update
fi
