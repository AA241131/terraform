output "vpc-id" {
  description = "ID del vpc creado por módulo"
  value = aws_vpc.terraform-vpc.id
}