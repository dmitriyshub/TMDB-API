# Terraform Outputs
output "instance_ami" {
  value = aws_instance.public-ec2.ami
}

output "instance_arn" {
  value = aws_instance.public-ec2.arn
}

output "public_ip" {
  value = aws_instance.public-ec2.public_ip
}

output "public_dns" {
  value = "http://${aws_instance.public-ec2.public_dns}:8080"
}
#################################################################
