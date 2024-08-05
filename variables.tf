variable "region" {
  description = "Server Region"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
}

variable "instance_type" {
  description = "EC2 Instance Type"
  type        = string
}

variable "public_subnet_cidr" {
  description = "Public Subnet CIDR"
  type        = list(string)
}

variable "map_public_ip_on_launch" {
  description = "Public Subnet MAP ID"
  type        = string
}
variable "associate_public_ip_address" {
  description = "Public associate_public_ip_address"
  type        = string
}
variable "enable_dns_hostnames" {
  description = "Enable dns hostnames is True"
  type        = string
}

variable "ebs_volume" {
  description = "volume type and volume size"
  type = list(object({
    v_type = string
    v_size = number
  }))

}

