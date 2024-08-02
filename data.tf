data "aws_availability_zones" "azs" {}
data "aws_ami" "ami_name" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-2023.5.20240730.0-kernel-6.1-x86_64"] # 0c11a84584d4e09dd For us-east-2 resion Free Tier
  }
  # filter {
  # name   = "name"
  # values = ["amzn2-ami-kernel-*-hvm-*-x86_64-gp2"]
  # }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}