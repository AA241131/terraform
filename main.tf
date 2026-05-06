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

module "desplegar-red" {
  source = "./modules/red"
  
  #variables para el modulo
  vpc_id = module.desplegar-vpc.vpc-id  
  subnet_id = [module.desplegar-instancia1.subnet-id, module.desplegar-instancia2.subnet-id]
  ec2_instance_id = [module.desplegar-instancia1.ec2-instance-id, module.desplegar-instancia2.ec2-instance-id]
  
}

module "desplegar-instancia1" {
  source = "./modules/instancia"
    
  #variables para el modulo
  AMI        = "ami-098e39bafa7e7303d"
  vpc_id     = module.desplegar-vpc.vpc-id
  subnet_cidr_block = "10.0.1.0/24"
  subnet_az = "us-east-1a"
  nombre_subnet = "subnet-1"
  nombre_instancia = "webapp-server01"
  rt_id = module.desplegar-red.rt-id
  sg_id = [module.desplegar-red.ssh-http-access-sg-id]
}

module "desplegar-instancia2" {
  source = "./modules/instancia"
    
  #variables para el modulo
  AMI        = "ami-098e39bafa7e7303d"
  vpc_id     = module.desplegar-vpc.vpc-id
  subnet_cidr_block = "10.0.2.0/24"
  subnet_az = "us-east-1b"
  nombre_subnet = "subnet-2"
  nombre_instancia = "webapp-server02"
  rt_id = module.desplegar-red.rt-id
  sg_id = [module.desplegar-red.ssh-http-access-sg-id]
}

#salidas
output "ec2-instance-id" {
value = module.desplegar-instancia1.ec2-instance-id
}

output "ec2-instance-public-ip" {
  description = "IP público de la instancia EC2 creada por el módulo"
  value = module.desplegar-instancia1.ec2-instance-public-ip
}

