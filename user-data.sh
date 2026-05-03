#!/bin/bash
yum update -y
yum -y install yum-utils
yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
yum -y install terraform
yum -y install git
git clone https://github.com/AA241131/terraform /home/ec2-user/repositorio
chmod 400 /home/ec2-user/repositorio/labuser.pem