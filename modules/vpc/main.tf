# Crear el VPC
resource "aws_vpc" "terraform-vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name      = var.nombre_vpc
  }
}