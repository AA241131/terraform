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

module "desplegar-vpc" {
  source = "./modules/vpc"
  #variables para el modulo
  vpc_cidr   = "10.0.0.0/16"
  nombre_vpc = "vpc-practico-3tier"
}

module "desplegar-instancia" {
  source = "./modules/instancia"
  count = 1
  
  #variables para el modulo
  AMI        = "ami-098e39bafa7e7303d"
  vpc_id     = module.desplegar-vpc.vpc-id

}

#salida desde el modulo
output "ec2-instance-id" {
value = module.desplegar-instancia.0.ec2-instance-id
}



