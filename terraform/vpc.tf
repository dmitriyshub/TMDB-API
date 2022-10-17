# Create VPC
resource "aws_vpc" "vpc" { # terraform id&name
  cidr_block = "172.16.0.0/16" # specify the network
  enable_dns_hostnames = true
  tags = {
      Name = "vpc" # aws Tag
      Env = var.Env_tag
  }
}
#################################################################
# Local variable
locals {
  account_id = aws_vpc.vpc.owner_id
}
#################################################################
# Availability zones
data "aws_availability_zones" "available" {
}
#################################################################
# PUBLIC Subnet 1
resource "aws_subnet" "vpc_subnet1_public" { # terraform id&name
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "172.16.1.0/24"
  availability_zone = var.az_a
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-a" # aws tag
    Env = var.Env_tag
  }
}
# PUBLIC Subnet 2
resource "aws_subnet" "vpc_subnet2_public" { # terraform id&name
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "172.16.10.0/24"
  availability_zone = var.az_b
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-b" # aws tag
    Env = var.Env_tag
  }
}
#################################################################
# PRIVATE Subnet 1
resource "aws_subnet" "vpc_subnet1_private" { # terraform id&name
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "172.16.2.0/24"
  availability_zone = var.az_a
  map_public_ip_on_launch = false

  tags = {
    Name = "private-subnet-a" # aws tag
    Env = var.Env_tag
  }
}
# PRIVATE Subnet 2
resource "aws_subnet" "vpc_subnet2_private" { # terraform id&name
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "172.16.20.0/24"
  availability_zone = var.az_b
  map_public_ip_on_launch = false

  tags = {
    Name = "private-subnet-b" # aws tag
    Env = var.Env_tag
  }
}
#################################################################
# Route Table for VPC PUBLIC
resource "aws_route_table" "vpc_route_table_public" {
  vpc_id = aws_vpc.vpc.id # attach to vpc

  route {
    cidr_block = "0.0.0.0/0" # ip range for this route
    gateway_id = aws_internet_gateway.vpc_internet_gateway.id # attach to internet gateway
  }

  tags = {
    Name = "route-table-public" # aws tag
    Env = var.Env_tag
  }
}
#################################################################
# Internet Gateway for VPC
resource "aws_internet_gateway" "vpc_internet_gateway" { # terraform id&name
  vpc_id = aws_vpc.vpc.id # attach to vpc
  tags = {
    Name = "internet-gateway" # aws tag
    Env = var.Env_tag
  }
}
#################################################################
# Route Table Association PUBLIC
resource "aws_route_table_association" "subnet_public_assosiacion1" {
  subnet_id      = aws_subnet.vpc_subnet1_public.id
  route_table_id = aws_route_table.vpc_route_table_public.id
}

resource "aws_route_table_association" "subnet_public_assosiacion2" {
  subnet_id      = aws_subnet.vpc_subnet2_public.id
  route_table_id = aws_route_table.vpc_route_table_public.id
}
#################################################################
# Route Table for VPC PRIVATE
resource "aws_route_table" "vpc_route_table_private" {
  vpc_id = aws_vpc.vpc.id # attach to vpc

  route {
    cidr_block = "0.0.0.0/0" # ip range for this route
    gateway_id = aws_nat_gateway.nat.id # attach to internet gateway
  }

  tags = {
    Name = "route-table-private" # aws tag
    Env = var.Env_tag
  }
}

#################################################################
# Route Table Association PRIVATE
resource "aws_route_table_association" "subnet_private_assosiacion1" {
  subnet_id      = aws_subnet.vpc_subnet1_private.id
  route_table_id = aws_route_table.vpc_route_table_private.id
}
resource "aws_route_table_association" "subnet_private_assosiacion2" {
  subnet_id      = aws_subnet.vpc_subnet2_private.id
  route_table_id = aws_route_table.vpc_route_table_private.id
}
#################################################################
# Elastic Ip Address
resource "aws_eip" "eip" {
  vpc      = true
}
#################################################################
# Nat Gateway
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.vpc_subnet1_public.id

  tags = {
    Name = "Nat Gateway" # aws tag
    Env = var.Env_tag
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.vpc_internet_gateway]
}
#################################################################