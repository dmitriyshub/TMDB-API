
# AMI Configuration
data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
}
#################################################################
# Create EC2
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
#################################################################




