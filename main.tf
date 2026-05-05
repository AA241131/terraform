provider "aws" {
region = "us-east-1"
}

module "deploy-instance" {
source = "./modules/custom-deploy"
count = 1
}

output "ec2-instance-id" {
value = module.deploy-instance.0.ec2-instance-id
}

output "ec2-instance-dns" {
value = module.deploy-instance.0.ec2-instance-dns
}


