region                  = "us-east-2"
vpc_cidr                = "172.0.0.0/16"
public_subnet_cidr      = ["172.0.0.0/24"]
instance_type           = "t2.medium"
map_public_ip_on_launch = true
enable_dns_hostnames    = true
associate_public_ip_address = true
ebs_volume = [{
  v_type = "gp3"
  v_size = 30
}]

