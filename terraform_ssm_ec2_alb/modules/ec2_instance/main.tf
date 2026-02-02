data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-2023*-x86_64"]
  }
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

resource "aws_instance" "ssm_demo" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = "t2.micro"
  iam_instance_profile        = aws_iam_instance_profile.ssm_profile.name
  vpc_security_group_ids      = [var.ec2_sg_id]
  subnet_id                   = var.subnet_id
  associate_public_ip_address = var.associate_public_ip
  tags = {
    Name = "ssm-demo-instance-jessamy"
  }
  depends_on = [aws_iam_instance_profile.ssm_profile]
    user_data = <<-EOF
      #!/bin/bash
      sudo dnf install docker -y
      sudo systemctl enable docker
      sudo systemctl start docker
      sudo usermod -aG docker ssm-user
      sudo docker run -d -p 8080:8080 jessamy/ssm-alb-app:latest
    EOF
}

resource "aws_lb_target_group_attachment" "jessamy_ec2_attach" {
  target_group_arn = var.tg_arn
  target_id        = aws_instance.ssm_demo.id
  port             = 8080
}
