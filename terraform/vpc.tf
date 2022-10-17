# Create VPC
resource "aws_vpc" "vpc" { # terraform id&name
  cidr_block = "172.16.0.0/16" # specify the network
  enable_dns_hostnames = true
  tags = {
      Name = "tmdb-vpc" # aws Tag
      Env = var.Env_tag
  }
}
#################################################################
# Availability zones
data "aws_availability_zones" "available" {
}

# PUBLIC Subnet
resource "aws_subnet" "vpc_subnet1_public" { # terraform id&name
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "172.16.10.0/24"
  availability_zone = var.public_az
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet" # aws tag
    Env = var.Env_tag
  }
}
#################################################################
# PRIVATE Subnet
resource "aws_subnet" "vpc_subnet2_private" { # terraform id&name
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "172.16.20.0/24"
  availability_zone = var.private_az
  map_public_ip_on_launch = false

  tags = {
    Name = "private-subnet" # aws tag
    Env = var.Env_tag
  }
}
#################################################################
# Route Table for VPC
resource "aws_route_table" "vpc_route_table_public" {
  vpc_id = aws_vpc.vpc.id # attach to vpc

  route {
    cidr_block = "0.0.0.0/0" # ip range for this route
    gateway_id = aws_internet_gateway.vpc_internet_gateway.id # attach to internet gateway
  }

  tags = {
    Name = "dmitriyshub-vpc-route-table" # aws tag
    Env = var.Env_tag
  }
}
#################################################################
# Internet Gateway for VPC
resource "aws_internet_gateway" "vpc_internet_gateway" { # terraform id&name
  vpc_id = aws_vpc.vpc.id # attach to vpc
  tags = {
    Name = "dmitriyshub-vpc-internet-gateway" # aws tag
    Env = var.Env_tag
  }
}
#################################################################
# Route Table Association
resource "aws_route_table_association" "subnet_public_assosiacion" {
  subnet_id      = aws_subnet.vpc_subnet1_public.id
  route_table_id = aws_route_table.vpc_route_table_public.id
}
#################################################################
# Local variable
locals {
  account_id = aws_vpc.vpc.owner_id
}
#################################################################
