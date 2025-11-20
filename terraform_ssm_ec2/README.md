

# Terraform: EC2 with SSM in Private Subnet (No SSH)

## Overview
This configuration provisions an EC2 instance in a private subnet, with no public IP and no SSH access, only accessible via AWS SSM.

### Key Features
- Security group with no inbound rules, all outbound allowed
- No SSH key assigned to EC2
- IAM role attached with AmazonSSMManagedInstanceCore
- S3 remote state management
- Subnet is private, requires NAT Gateway for outbound access

## Steps
1. Run `terraform init` to initialize the backend
2. Run `terraform apply` to create all resources
   - VPC, private subnet, NAT Gateway, route table, IAM role, EC2 instance
3. After creation, check in AWS Console:
   - VPC DNS resolution and DNS hostnames are both enabled
   - Private subnet route table has 0.0.0.0/0 pointing to NAT Gateway
   - EC2 instance appears in Systems Manager → Managed Instances
   - You can connect via Session Manager
4. Destroy resources: `terraform destroy -auto-approve`

## SSM Troubleshooting Tips
- Use the official AWS Amazon Linux 2023 AMI
- Add user_data to EC2 to restart SSM agent on boot
- Ensure all dependencies (NAT, route, IAM) are fully available before creating EC2
- If SSM registration fails, check VPC DNS, outbound network, IAM role, and AMI type first

## File Descriptions
- `main.tf`: core resource definitions
- `variables.tf`: input variables
- `outputs.tf`: output values
- `backend.tf`: remote state configuration

## Security & Compliance
- Security group has no inbound rules, all access via SSM
- All sessions are audited in SSM Session History

## Recommended Verification Screenshots
- IAM Role with AmazonSSMManagedInstanceCore
- Security Group with no inbound rules
- EC2 instance details (no keypair, correct IAM profile, private subnet)
- Instance in SSM Managed Instances
- Successful Session Manager shell
