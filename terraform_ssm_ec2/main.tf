# Create EIP for NAT Gateway
resource "aws_eip" "nat_eip" {

}

# Create NAT Gateway in public subnet
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = var.public_subnet_id # Public subnet for NAT
  tags = {
    Name = "Sample-natgw-jessamy"
  }
}

# Create private route table
resource "aws_route_table" "private" {
  vpc_id = var.vpc_id
  tags = {
    Name = "Sample-rtb-private1-ap-southeast-2a-jessamy"
  }
}

# Add default route to NAT Gateway
resource "aws_route" "private_nat" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

# Associate private subnet with private route table
resource "aws_route_table_association" "private_subnet" {
  subnet_id      = var.subnet_id
  route_table_id = aws_route_table.private.id
}
variable "region" {
  description = "AWS region to deploy to"
  type        = string
  default     = "ap-southeast-2"
}
provider "aws" {
  region = var.region
}

resource "aws_iam_role" "ssm_role" {
  name        = "iam-ssm-jessamy"
  description = "EC2 SSM access for jessamy"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
  tags = {
    Name = "jessamy"
  }
}

resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ssm_profile" {
  name = "iam-ssm-jessamy"
  role = aws_iam_role.ssm_role.name
}

resource "aws_security_group" "no_inbound" {
  name        = "ec2-ssm-no-inbound-sg-jessamy"
  description = "No inbound, all outbound"
  vpc_id      = var.vpc_id

  # No ingress block (no inbound rules)

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-2023*-x86_64"] # 官方标准版 Amazon Linux 2023
  }
}

resource "aws_instance" "ssm_demo" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = "t2.micro"
  iam_instance_profile        = aws_iam_instance_profile.ssm_profile.name
  vpc_security_group_ids      = [aws_security_group.no_inbound.id]
  subnet_id                   = var.subnet_id
  associate_public_ip_address = var.associate_public_ip
  tags = {
    Name = "ssm-demo-instance-jessamy"
  }
  # No key_name: proves no SSH
  depends_on = [
    aws_nat_gateway.nat,
    aws_route_table.private,
    aws_iam_instance_profile.ssm_profile
  ]
  user_data = <<-EOF
    #!/bin/bash
    sudo systemctl restart amazon-ssm-agent
  EOF
}
