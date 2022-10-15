
variable "region" {
  description = "AWS region"
  default     = "eu-central-1"
}

variable "public_az" {
  description = "AWS Availability zone"
  default     = "eu-central-1a"
}

variable "private_az" {
  description = "AWS Availability zone"
  default     = "eu-central-1b"
}

variable "instance_type" {
  description = "Type of EC2 instance to provision"
  default     = "t2.small"
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