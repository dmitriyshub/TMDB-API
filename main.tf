# 1. Create a `main.tf` file in the root of this repository with the `remote` backend and one or more resources defined.
#   Example `main.tf`:
     # The configuration for the `remote` backend.
     terraform {
       backend "remote" {
         # The name of your Terraform Cloud organization.
         organization = "dmitriyshub"

         # The name of the Terraform Cloud workspace to store Terraform state files in.
         workspaces {
           name = "github-actions-tmdb-api"
         }
       }

     }

     # An example resource that does nothing.
     resource "null_resource" "example" {
       triggers = {
         value = "A example resource that does nothing!"
       }
     }

resource "aws_vpc" "vpc" { # terraform id&name
  cidr_block = "172.16.0.0/16" # specify the network
  tags = {
      Name = "dmitriyshub-vpc" # aws Tag
  }
}