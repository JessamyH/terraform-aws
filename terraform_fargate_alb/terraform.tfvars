node_app_image = "jessamy/node-app-jessamy:latest"
nginx_image    = "jessamy/nginx-proxy-jessamy:latest"
node_app_port  = 3000
nginx_port     = 80


# VPC and Subnet configuration
# Public subnets (for ALB, NAT Gateway)
public_subnet_ids = [
  "subnet-0a05dfbfa9b02eb45", # Sample-subnet-public1-ap-southeast-2a
  "subnet-044bb7e2c10d0b1ee"  # Sample-subnet-public2
]
# VPC
vpc_id = "vpc-0a775837570253930" # Sample VPC
# Private subnet (for EC2, Fargate)
subnet_id = "subnet-089bf9a6ed97aad05" # Sample-subnet-private1-ap-southeast-2a
