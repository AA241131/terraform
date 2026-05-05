provider "aws" {
region = "us-east-1"
}

#crear bucket
resource "aws_s3_bucket" "bucket-S3" {
  bucket = "terraform-state-aacosta"
}

#state.tf
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
}

output "ec2-instance-id" {
value = module.deploy-instance.0.ec2-instance-id
}

output "ec2-instance-dns" {
value = module.deploy-instance.0.ec2-instance-dns
}


