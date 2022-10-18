#!/bin/bash
#Start
yum update -y
yum install -y git
git clone https://github.com/dmitriyshub/TMDB-API.git /home/ec2-user/app
mkdir /home/ec2-user/.aws
mkdir /home/ec2-user/app/secret

#configure aws region
export AWS_DEFAULT_REGION=eu-central-1
echo '[default]' >> /home/ec2-user/.aws/config
echo 'output = json' >> /home/ec2-user/.aws/config
echo 'region = eu-central-1' >> /home/ec2-user/.aws/config
sleep 5

#get api token .env
# TODO secret manager
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
docker-compose -f /home/ec2-user/app/docker-compose.yml up -d

# These lines erase any history or security information that may have accidentally been left on the instance when the image was taken.
echo 'UserData has been successfully executed. ' >> /home/ec2-user/result
find -wholename "/root/.*history" -wholename "/home/*/.*history" -exec rm -f {} \;
find / -name 'authorized_keys' -exec rm -f {} \;
rm -rf /var/lib/cloud/data/scripts/*



