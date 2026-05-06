variable "vpc_id" {
  type = string
  description = "Variable para el ID de la VPC"
}   

variable "subnet_id" {
  type = list(string)
  description = "Variable para el ID de las subnets"
}