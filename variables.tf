variable "aws_region" {
  type = string
  description = "Variable para la region"
}

variable "vpc_cidr" {
  type = string
  description = "Variable para el CIDR block"
}

variable "AMI" {
  type = string
  description = "Variable para la AMI"
}

variable "bastion_private_key" {
  type = string
  description = "Variable para la llave privada del bastion"
}