# 1. Create a `main.tf` file in the root of this repository with the `remote` backend and one or more resources defined.
#   Example `main.tf`:
     # The configuration for the `remote` backend.
#     terraform {
#       backend "remote" {
#         # The name of your Terraform Cloud organization.
#         organization = "dmitriyshub"
#
#         # The name of the Terraform Cloud workspace to store Terraform state files in.
#         workspaces {
#           name = "github-actions-tmdb-api"
#         }
#       }
#
#     }
#######terraform###########init###########terraform#############
terraform {

  cloud {
    organization = "dmitriyshub"

    workspaces {
      name = "github-actions-tmdb-api"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.28.0"
    }
  }

  required_version = ">= 0.14.0"
}


provider "aws" {
  region = var.region
}
#######AMI###########AMI###########AMI########################
data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
}
# create private vpc
resource "aws_vpc" "vpc" { # terraform id&name
  cidr_block = "172.16.0.0/16" # specify the network
  tags = {
      Name = "tmdb-vpc" # aws Tag
      Env = var.Env_tag
  }
}
#end vpc


data "aws_availability_zones" "available" {
}

#2 create subnets
# PUBLIC subnet
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
# PRIVATE subnet
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

#3 create a route table for vpc
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

#4 create internet gateway for vpc
resource "aws_internet_gateway" "vpc_internet_gateway" { # terraform id&name
  vpc_id = aws_vpc.vpc.id # attach to vpc
  tags = {
    Name = "dmitriyshub-vpc-internet-gateway" # aws tag
    Env = var.Env_tag
  }
}

resource "aws_route_table_association" "subnet_public_assosiacion" {
  subnet_id      = aws_subnet.vpc_subnet1_public.id
  route_table_id = aws_route_table.vpc_route_table_public.id
}


#######Infrastracture###########EC2###########EC2########################
#6 create ec2
resource "aws_instance" "public-ec2" { # terraform id&name
  ami           = data.aws_ami.amazon-linux-2.id
  instance_type = var.instance_type
  key_name = var.key_pair
  user_data = "${file("ec2-user-data.sh")}"

  tags = {
    Name = var.instance_name
    Env = var.Env_tag
  }

  vpc_security_group_ids = [aws_security_group.public_security_group.id] # attach ec2 to security group
  subnet_id = aws_subnet.vpc_subnet1_public.id # attach ec2 to subnet
  associate_public_ip_address = true # get automatic public ip
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name


  credit_specification {
    cpu_credits = "unlimited"
  }
  lifecycle {
    create_before_destroy = true
  }
}

#7 create security group
resource "aws_security_group" "public_security_group" { # terraform id&name
  name        = "bastion1 security group"
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
  # outbound rule
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

#8 create inbound ssh rules and attach to security group
resource "aws_security_group_rule" "public_ssh_access" { # terraform id&name
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.public_security_group.id # attach rule to security group
}

locals {
  account_id = aws_vpc.vpc.owner_id
}
