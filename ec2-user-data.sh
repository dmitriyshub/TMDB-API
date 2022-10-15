#!/bin/bash
yum update -y
amazon-linux-extras install docker
service docker start
usermod -a -G docker ec2-user
sudo chkconfig docker on
sudo yum install -y git
sudo curl -L https://github.com/docker/compose/releases/download/1.22.0/docker-compose-"$(uname -s)"-"$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

mkdir /home/ec2-user/tmdb-api && cd /home/ec2-user/tmdb-api || cd /
git clone https://github.com/dmitriyshub/TMDB-API.git
docker-compose up -d


