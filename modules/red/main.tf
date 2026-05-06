#crear el Internet Gateway
resource "aws_internet_gateway" "terraform-ig" {
  vpc_id = var.vpc_id

  tags = {
    Name = "terraform-ig"
  }
}

#crear la route table
resource "aws_route_table" "terraform-rt" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terraform-ig.id
  }
  
  tags = {
    Name = "terraform-rt"
  }
}

#crear el security group 
resource "aws_security_group" "ssh-http-access-sg" {
  name = "ssh-http-access"
  vpc_id = var.vpc_id
  tags = {
    Name      = "ssh-http-access"
  }
}

#crear regla en ingreso ssh en sg
resource "aws_vpc_security_group_ingress_rule" "ssh-ingreso" {
  security_group_id = aws_security_group.ssh-http-access-sg.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 22
  ip_protocol = "tcp"
  to_port     = 22
}

# permitir http 
resource "aws_vpc_security_group_ingress_rule" "http-ingreso" {
  security_group_id = aws_security_group.ssh-http-access-sg.id
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_ipv4         = "0.0.0.0/0"
}

#regla de egreso de sg
resource "aws_vpc_security_group_egress_rule" "sg-egress" {
  security_group_id = aws_security_group.ssh-http-access-sg.id

  ip_protocol = "-1"          # todos los protocolos
  cidr_ipv4   = "0.0.0.0/0"   
}

#crear el load balancer
resource "aws_lb" "terraform-lb" {
  name               = "ALB"  
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ssh-http-access-sg.id]
  subnets            = var.subnet_id
}


resource "aws_lb_target_group" "target_group" {
  name     = "target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_target_group_attachment" "asociacion1" {
  target_group_arn = aws_lb_target_group.target_group.arn
  target_id        = var.ec2_instance_id[0] # Asocia la primera instancia EC2 al target group
  port             = 80
}

resource "aws_lb_target_group_attachment" "asociacion2" {
  target_group_arn = aws_lb_target_group.target_group.arn
  target_id        = var.ec2_instance_id[1] # Asocia la segunda instancia EC2 al target group
  port             = 80
}

resource "aws_lb_listener" "ALB_listener" {
  load_balancer_arn = aws_lb.terraform-lb.arn
  port              = "80"
  protocol          = "HTTP"
  

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}