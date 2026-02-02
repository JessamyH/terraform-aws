// Create EIP for NAT Gateway
resource "aws_eip" "nat_eip" {

}

// Create NAT Gateway in public subnet
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = var.public_subnet_ids[0] // 用第一个公网子网
  tags = {
    Name = "Sample-natgw-jessamy"
  }
}

// Create private route table
resource "aws_route_table" "private" {
  vpc_id = var.vpc_id
  tags = {
    Name = "Sample-rtb-private1-ap-southeast-2a-jessamy"
  }
}

// Add default route to NAT Gateway
resource "aws_route" "private_nat" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

// Associate private subnet with private route table
resource "aws_route_table_association" "private_subnet" {
  subnet_id      = var.subnet_id
  route_table_id = aws_route_table.private.id
}
// AWS region configuration
variable "region" {
  description = "AWS region to deploy to"
  type        = string
  default     = "ap-southeast-2"
}

provider "aws" {
  region = var.region
}

// NAT, VPC, Route Table, EIP resources are reused from previous setup

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

// EC2 Instance module: creates EC2 instance, IAM role/profile, registers to TG
module "ec2_instance" {
  source              = "./modules/ec2_instance"
  subnet_id           = var.subnet_id
  associate_public_ip = var.associate_public_ip
  ec2_sg_id           = module.security_group.ec2_sg_id
  tg_arn              = module.alb.tg_arn
}
