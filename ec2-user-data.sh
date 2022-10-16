#!/bin/bash
yum update -y
yum install -y git
git clone https://github.com/dmitriyshub/TMDB-API.git /home/$USER/app
account='[default]'
output='output = json'
region='region = eu-central-1'
mkdir /home/$USER/.aws ;
printf  "$account" "$output" "$region" > /home/$USER/.aws/config
aws ssm get-parameter --name /dev/api_key --with-decryption --query 'Parameter.Value' > /home/$USER/app/.env

amazon-linux-extras install docker -y
systemctl start docker
systemctl enable docker
usermod -a -G docker ec2-user
curl -L https://github.com/docker/compose/releases/download/1.22.0/docker-compose-"$(uname -s)"-"$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

# mkdir /home/ec2-user/tmdb-api && cd /home/ec2-user/tmdb-api || cd /
docker-compose -f /home/$USER/app/docker-compose.yml up -d

