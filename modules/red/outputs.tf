output "rt-id" {
  description = "ID de la tabla de rutas creada por el módulo"
  value = aws_route_table.terraform-rt.id
}

output "ssh-http-access-sg-id" {
  description = "ID de la tabla de rutas creada por el módulo"
  value = aws_route_table.ssh-http-access-sg.id
}