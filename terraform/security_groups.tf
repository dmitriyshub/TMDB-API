#  Security Group
resource "aws_security_group" "public_security_group" { # terraform id&name
  name        = "Public security group"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.vpc.id # attach security group to vpc

  dynamic "ingress" {
    for_each = ["80", "443", "8080"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  # Outbound rule
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "public-security-group"
    Env = var.Env_tag
  }
}
#################################################################

# Attach inbound SSH rules to Security Group
resource "aws_security_group_rule" "public_ssh_access" { # terraform id&name
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.public_security_group.id # attach rule to security group
}
#################################################################
resource "aws_security_group" "private_security_group" { # terraform id&name
  name        = "Public security group"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.vpc.id # attach security group to vpc

  dynamic "ingress" {
    for_each = ["8080"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  # Outbound rule
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "private-security-group"
    Env = var.Env_tag
  }
}
# Attach inbound SSH rules to Security Group
resource "aws_security_group_rule" "public_ssh_access" { # terraform id&name
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["172.16.0.0/16"]
  security_group_id = aws_security_group.private_security_group.id # attach rule to security group
}