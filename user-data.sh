#!/bin/bash
yum update -y
yum -y install yum-utils
yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
yum -y install terraform
terraform -version
mkdir /home/repositorio
git clone https://github.com/AA241131/terraform /home/repositorio