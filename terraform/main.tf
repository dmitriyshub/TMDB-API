# Terraform Provider Info
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
#################################################################












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