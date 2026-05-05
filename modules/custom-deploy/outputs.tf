output "ec2-instance-id" {
  description = "ID de la instancia EC2 creada por el módulo"
  value = aws_instance.test-terraform-ec2.id
}

output "ec2-instance-public-ip" {
  description = "IP público de la instancia EC2 creada por el módulo"
  value = aws_instance.test-terraform-ec2.public_ip
}