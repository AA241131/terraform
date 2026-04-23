#Configurar el provider
#Crear una instancia de EC2

provider "aws" {
  region  = "us-east-1a"
}

variable "key-pair" {
  type = string
  default = "vockey"
}

# Crear el VPC
resource "aws_vpc" "test-terraform-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name      = "test-terraform-vpc"
  }
}

#Crear la subnet
resource "aws_subnet" "vpc-subnet" {
  vpc_id     = aws_vpc.test-terraform-vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name      = "vpc-subnet"
  }
}

#crear el security group
resource "aws_security_group" "test-terraform-sg" {
  name = "test-terraform-sg"
  vpc_id = aws_vpc.test-terraform-vpc.id
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name      = "test-terraform-sg"
  }
}

#crear el internet gateway
resource "aws_internet_gateway" "test-terraform-ig" {
  vpc_id = aws_vpc.test-terraform-vpc.id

  tags = {
    Name = "test-terraform-ig"
  }
}

#crear la instancia
resource "aws_instance" "test-terraform-ec2" {
  ami                    = "ami-098e39bafa7e7303d"
  instance_type          = "t3.micro"
  key_name               = var.key-pair
  vpc_security_group_ids = [aws_security_group.test-terraform-sg.id]
  subnet_id              = aws_subnet.vpc-subnet.id
  tags = {
    Name      = "test-terraform-ec2"
  }
}

