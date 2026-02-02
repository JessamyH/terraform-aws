resource "aws_cloudwatch_log_group" "node_app" {
  name              = "/ecs/node-app-jessamy"
  retention_in_days = 7
}

resource "aws_cloudwatch_log_group" "nginx_proxy" {
  name              = "/ecs/nginx-proxy-jessamy"
  retention_in_days = 7
}

module "ecs_fargate_nginx" {
  source           = "./modules/ecs_fargate_nginx"
  project_name     = "ecs-fargate-demo"
  cluster_name     = "jessamy-ecs-cluster"
  task_family      = "jessamy-task"
  cpu              = "512"
  memory           = "1024"
  container_name   = "node-app-jessamy"
  service_name     = "jessamy-service"
  desired_count    = 1
  subnets          = [var.subnet_id]
  security_groups  = [module.security_group.ec2_sg_id]
  target_group_arn = module.alb.tg_arn
  region           = var.region
  node_app_image   = var.node_app_image
  nginx_image      = var.nginx_image
  node_app_port    = var.node_app_port
  nginx_port       = var.nginx_port
}

provider "aws" {
  region = var.region
}

// NAT Gateway, EIP, Route Table, and association for private subnet
resource "aws_eip" "nat_eip" {}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = var.public_subnet_ids[0]
  tags = {
    Name = "natgw-jessamy"
  }
}

resource "aws_route_table" "private" {
  vpc_id = var.vpc_id
  tags = {
    Name = "rtb-private-jessamy"
  }
}

resource "aws_route" "private_nat" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

resource "aws_route_table_association" "private_subnet" {
  subnet_id      = var.subnet_id
  route_table_id = aws_route_table.private.id
}

// Security Group module: creates ALB and EC2 security groups
module "security_group" {
  source = "./modules/security_group"
  vpc_id = var.vpc_id
}

// ALB module: creates Application Load Balancer, Target Group, Listener
module "alb" {
  source            = "./modules/alb"
  public_subnet_ids = var.public_subnet_ids
  vpc_id            = var.vpc_id
  alb_sg_id         = module.security_group.alb_sg_id
}



