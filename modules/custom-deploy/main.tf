
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

#Asociar la tabla a la subnet
resource "aws_route_table_association" "example" {
  subnet_id      = aws_subnet.vpc-subnet.id
  route_table_id = aws_route_table.terraform-rt.id
}

#crear el security group 
resource "aws_security_group" "test-terraform-sg" {
  name = "test-terraform-sg"
  vpc_id = aws_vpc.test-terraform-vpc.id
  tags = {
    Name      = "test-terraform-sg"
  }
}

#crear regla en ingreso ssh en sg
resource "aws_vpc_security_group_ingress_rule" "ssh-ingreso" {
  security_group_id = aws_security_group.test-terraform-sg.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 22
  ip_protocol = "tcp"
  to_port     = 22
}

# permitir http 
resource "aws_vpc_security_group_ingress_rule" "http-ingreso" {
  security_group_id = aws_security_group.test-terraform-sg.id
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_ipv4         = "0.0.0.0/0"
}

#regla de egreso de sg
resource "aws_vpc_security_group_egress_rule" "sg-egress" {
  security_group_id = aws_security_group.test-terraform-sg.id

  ip_protocol = "-1"          # todos los protocolos
  cidr_ipv4   = "0.0.0.0/0"   
}

#crear la instancia
resource "aws_instance" "test-terraform-ec2" {
  ami                    = var.AMI
  instance_type          = "t2.micro"
  key_name               = var.key-pair
  vpc_security_group_ids = [aws_security_group.test-terraform-sg.id]
  subnet_id              = aws_subnet.vpc-subnet.id
  iam_instance_profile   = "LabInstanceProfile"  #para troubleshooting
  tags = {
    Name      = "test-terraform-ec2"
  }

  connection {
    type     = "ssh"
    user     = "ec2-user"
    host     = self.public_ip
    private_key = file("/home/ec2-user/repositorio/labsuser.pem")
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum install httpd -y",
      "sudo systemctl start httpd",
      "sudo systemctl enable httpd",
      "sudo yum install git -y",
      "sudo git clone https://github.com/mauricioamendola/chaos-monkey-app.git /var/www/html",
      "sudo mv /var/www/html/website/* /var/www/html"
      ]
  }
}