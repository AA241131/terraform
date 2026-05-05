provider "aws" {
region = var.region
}



#state.tf, bucket tiene que estar previamente creado
terraform {  
  backend "s3" {
    #encrypt = true
    bucket = "terraform-state-aacosta"
    #dynamodb_table = "terraformmydb"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}

module "deploy-instance" {
  source = "./modules/custom-deploy"
  count = 1
  
  #variables para el modulo
  vpc_cidr   = "172.16.0.0/16"
  AMI        = "ami-098e39bafa7e7303d"
}

#salida desde el modulo
output "ec2-instance-id" {
value = module.deploy-instance.0.ec2-instance-id
}



