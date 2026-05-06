variable "vpc_id" {
  type = string
  description = "Variable para el ID de la VPC"
}   

variable "subnet_id" {
  type = list(string)
  description = "Variable para el ID de las subnets"
}

variable "ec2_instance_id" {
  type = list(string)
  description = "Variable para las ID de las instancias EC2"
}