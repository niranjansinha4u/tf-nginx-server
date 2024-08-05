locals {
  name = "tf-nginx"
}

# VPC Setup
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  #   version = "5.9.0"
  name                    = "${local.name}-vpc"
  cidr                    = var.vpc_cidr
  azs                     = data.aws_availability_zones.azs.names
  public_subnets          = var.public_subnet_cidr
  map_public_ip_on_launch = var.map_public_ip_on_launch
  enable_dns_hostnames    = var.enable_dns_hostnames
  tags = {
    Name        = "${local.name}-vpc"
    Terraform   = "true"
    Environment = "dev"
  }
  public_subnet_tags = {
    Name = "${local.name}-subnet"
  }

}

# SG
module "sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "${local.name}-sg"
  description = "Security Group for Jenkins Nginx Server"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      description = "HTTP"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "SSH"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "SSH"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 9090
      to_port     = 9090
      protocol    = "tcp"
      description = "SSH"
      cidr_blocks = "0.0.0.0/0"
    }
    ,
    {
      from_port   = 3000
      to_port     = 3000
      protocol    = "tcp"
      description = "SSH"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 9000
      to_port     = 9000
      protocol    = "tcp"
      description = "SSH"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  tags = {
    Name        = "${local.name}-sg"
    Environment = "Dev"
  }
}


# EC2 Setup
module "ec2_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name                        = "${local.name}-Server"
  ami                         = data.aws_ami.ami_name.id
  instance_type               = var.instance_type
  key_name                    = "CICD-SERVER"
  monitoring                  = true
  vpc_security_group_ids      = [module.sg.security_group_id]
  subnet_id                   = module.vpc.public_subnets[0]
  associate_public_ip_address = var.associate_public_ip_address
  user_data                   = file("cicd-install.sh")
  availability_zone           = data.aws_availability_zones.azs.names[0]


  root_block_device = [{
    volume_type           = var.ebs_volume[0].v_type
    volume_size           = var.ebs_volume[0].v_size
    delete_on_termination = true
  }]


  tags = {
    Name        = "${local.name}-Server"
    Terraform   = "true"
    Environment = "dev"
  }
}
