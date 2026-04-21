#Configurar el provider
#Crear una instancia de EC2

provider "aws" {
  region  = "us-east-1"
}
resource "aws_instance" "nombre-resource" {
  ami                    = "ami-098e39bafa7e7303d"
  instance_type          = "t3.micro"
  key_name               = "key-pair-ssh"
  vpn_security_group_ids = "sg-0efa0a996a948f66c"
  tags = {
    Name      = "test-terraform-ec2"
  }
}
