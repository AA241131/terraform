variable "AMI" {
  type = string
  description = "Variable para la AMI"
}

variable "key-pair" {
  type = string
  default = "vockey"
}

variable "vpc_id" {
  type = string
  description = "Variable para el ID de la VPC"
}