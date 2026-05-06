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

variable "nombre_instancia" {
  type = string
  description = "Variable para el nombre de la instancia"
}

variable "subnet_cidr_block" {
  type = string
  description = "Variable para el bloque CIDR de la subnet"
}

variable "subnet_az" {
  type = string
  description = "Variable para la zona de disponibilidad de la subnet"
}

variable "nombre_subnet" {
  type = string
  description = "Variable para el nombre de la subnet"
}

variable "rt_id" {
  type = string
  description = "Variable para el ID de la tabla de rutas"
}

variable "sg_id" {
  type = list(string)
  description = "Variable para el ID del security group"
}