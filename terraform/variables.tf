# Terraform Variables
variable "region" {
  description = "AWS region"
  default     = "eu-central-1"
}

variable "az_a" {
  description = "AWS Availability zone"
  default     = "eu-central-1a"
}

variable "az_b" {
  description = "AWS Availability zone"
  default     = "eu-central-1b"
}

variable "instance_type" {
  description = "Type of EC2 instance to provision"
  default     = "t2.micro"
}

variable "instance_name" {
  description = "EC2 instance name"
  default     = "Public-EC2"
}

variable "Env_tag" {
  description = "EC2 instance tag"
  default     = "Terraform"
}

variable "key_pair" {
  description = "key pair name"
  default     = "tmdb-key-pair"
}
variable "ami_id" {
  description = "tmdb ami id"
  default     = ami-0af81cabb6b3ea5e9
}

#################################################################
