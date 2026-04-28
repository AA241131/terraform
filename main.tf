#Configurar el provider
#Crear una instancia de EC2

provider "aws" {
  region  = var.aws_region
}

variable "key-pair" {
  type = string
  default = "vockey"
}

# Crear el VPC
resource "aws_vpc" "test-terraform-vpc" {
  cidr_block = "172.16.0.0/16"
  tags = {
    Name      = "test-terraform-vpc"
  }
}

#Crear la subnet
resource "aws_subnet" "vpc-subnet" {
  vpc_id     = aws_vpc.test-terraform-vpc.id
  cidr_block = "172.16.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = "true"
  tags = {
    Name      = "vpc-subnet"
  }
}

#crear el internet gateway
resource "aws_internet_gateway" "test-terraform-ig" {
  vpc_id = aws_vpc.test-terraform-vpc.id

  tags = {
    Name = "test-terraform-ig"
  }
}

#crear la route table
resource "aws_route_table" "terraform-rt" {
  vpc_id = aws_vpc.test-terraform-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.test-terraform-ig.id
  }
  
  tags = {
    Name = "test-terrafor-rt"
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

#crear la instancia
resource "aws_instance" "test-terraform-ec2" {
  ami                    = var.AMI
  instance_type          = "t2.micro"
  key_name               = var.key-pair
  vpc_security_group_ids = [aws_security_group.test-terraform-sg.id]
  subnet_id              = aws_subnet.vpc-subnet.id
  tags = {
    Name      = "test-terraform-ec2"
  }

  connection {
    type     = "ssh"
    user     = "root"
    host     = self.public_ip
    private_key = file("/etc/ssh/ssh_host_ed25519_key")
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir /home/testprovisioner",
      "echo "Hola Mundo" > /home/testprovisioner/test.txt",
    ]
  }
}


