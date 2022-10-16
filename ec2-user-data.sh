#!/bin/bash
yum update -y
yum install -y git
git clone https://github.com/dmitriyshub/TMDB-API.git /home/ec2-user/app
mkdir /home/ec2-user/.aws
mkdir /home/ec2-user/app/secret
#configure aws region
echo '[default]' >> /home/ec2-user/.aws/config
echo 'output = json' >> /home/ec2-user/.aws/config
echo 'region = eu-central-1' >> /home/ec2-user/.aws/config
sleep 10
#get api token .env
aws ssm get-parameter --name /dev/api_key --with-decryption --query 'Parameter.Value' | cut -d "\"" -f 2 > /home/ec2-user/app/secret/.env
sudo chown -R ec2-user:ec2-user /home/ec2-user/app /home/ec2-user/.aws /home/ec2-user/app/secret /home/ec2-user/.aws/config /home/ec2-user/app/secret/.env

#install docker
amazon-linux-extras install docker -y
systemctl start docker
systemctl enable docker
usermod -a -G docker ec2-user
curl -L https://github.com/docker/compose/releases/download/1.22.0/docker-compose-"$(uname -s)"-"$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
chown root:docker /usr/local/bin/docker-compose
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

# mkdir /home/ec2-user/tmdb-api && cd /home/ec2-user/tmdb-api || cd /
docker-compose -f /home/ec2-user/app/docker-compose.yml up -d

