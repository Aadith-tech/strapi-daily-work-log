#!/bin/bash

set -e

yum update -y

yum install -y docker


systemctl start docker
systemctl enable docker

usermod -aG docker ec2-user


sleep 5

mkdir -p /home/ec2-user/strapi
cd /home/ec2-user/strapi


cat > .env << 'ENVFILE'
# Server
HOST=0.0.0.0
PORT=1337

# Database - RDS PostgreSQL
DATABASE_CLIENT=postgres
DATABASE_HOST=${db_host}
DATABASE_PORT=${db_port}
DATABASE_NAME=${db_name}
DATABASE_USERNAME=${db_username}
DATABASE_PASSWORD=${db_password}
DATABASE_SSL=true
DATABASE_SSL_REJECT_UNAUTHORIZED=false

# Strapi Secrets
APP_KEYS=${app_keys}
API_TOKEN_SALT=${api_token_salt}
ADMIN_JWT_SECRET=${admin_jwt_secret}
JWT_SECRET=${jwt_secret}

ENVFILE

chown -R ec2-user:ec2-user /home/ec2-user/strapi

docker pull ${docker_image}

docker run -d \
  --name strapi \
  --restart unless-stopped \
  -p 1337:1337 \
  --env-file /home/ec2-user/strapi/.env \
  ${docker_image}






