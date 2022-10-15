# 1. Create a `main.tf` file in the root of this repository with the `remote` backend and one or more resources defined.
#   Example `main.tf`:
     # The configuration for the `remote` backend.
     terraform {
       required_providers {
         aws = {
           source  = "hashicorp/aws"
           version = "~> 4.16"
         }
       }
       backend "remote" {
         # The name of your Terraform Cloud organization.
         organization = "dmitriyshub"

         # The name of the Terraform Cloud workspace to store Terraform state files in.
         workspaces {
           name = "github-actions-tmdb-api"
         }
       }
         required_version = ">= 1.2.0"
     }

     provider "aws" {
       region  = "eu-central-1"
     }

     resource "aws_vpc" "main" {
       cidr_block = "10.0.0.0/16"
       instance_tenancy = "default"

       tags = {
         Name = "main"
       }
     }

     resource "aws_internet_gateway" "maingw" {
       vpc_id = aws_vpc.main.id

       tags = {
         Name = "main-gw"
       }
     }

     resource "aws_route_table" "mainroutetable" {
       vpc_id = aws_vpc.main.id

       route {
         cidr_block = "0.0.0.0/0"
         gateway_id = aws_internet_gateway.maingw.id
       }
       route {
         cidr_block = "10.0.0.0/16"
         local_gateway_id = "local"

       }

       tags = {
       Name = "main-route-table"
       }
     }
