#Crear la Subnet
resource "aws_subnet" "vpc-subnet" {
  vpc_id     = aws_vpc.test-terraform-vpc.id
  cidr_block = var.subnet_cidr_block
  availability_zone = var.subnet_az
  map_public_ip_on_launch = "true"
  tags = {
    Name      = var.nombre_subnet
  }
}

#Asociar la tabla a la subnet
resource "aws_route_table_association" "rt-association" {
  subnet_id      = aws_subnet.vpc-subnet.id
  route_table_id = var.rt_id
}

#crear la instancia
resource "aws_instance" "test-terraform-ec2" {
  ami                    = var.AMI
  instance_type          = "t2.micro"
  key_name               = var.key-pair
  vpc_security_group_ids = var.sg_id
  subnet_id              = aws_subnet.vpc-subnet.id
  iam_instance_profile   = "LabInstanceProfile"  #para troubleshooting
  tags = {
    Name      = var.nombre_instancia
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