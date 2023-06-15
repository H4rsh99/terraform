# Define variables
variable "ami_id" {
  description = "AMI ID for the instances"
  type        = string
  default     = "ami-053b0d53c279acc90"
}

# VPC
variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_name" {
  type    = string
  default = "opensearch_tool"
}

# public-subnet
variable "public_subnet_cidr_block" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.0.0.0/24"
}
variable "pub_subnet_name" {
  type    = string
  default = "public-subnet"
}

variable "pub_subnet_zone" {
  type    = string
  default = "us-east-1a"
}
#public instances
variable "instance_type" {
  type    = string
  default = "t2.medium"
}
variable "instance_name" {
  type    = string
  default = "bastion-server"
}

variable "key_public" {
  type    = string
  default = "private-key.pem"
}
# Define private subnet 1 CIDR block
variable "private_subnet_1_cidr_block" {
  description = "CIDR block for private subnet 1"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet1_zone" {
  type    = string
  default = "us-east-1a"
}

variable "private_subnet1_name" {
  type    = string
  default = "private-subnet-1"
}
# Define private subnet 2 CIDR block
variable "private_subnet_2_cidr_block" {
  description = "CIDR block for private subnet 2"
  type        = string
  default     = "10.0.2.0/24"
}

variable "private_subnet2_zone" {
  type    = string
  default = "us-east-1b"
}

variable "private_subnet2_name" {
  type    = string
  default = "private-subnet-2"
}


#security groups

variable "private_sg1_name" {
  type    = string
  default = "private-subnet-1-sg"
}

variable "private_sg2_name" {
  type    = string
  default = "private-subnet-12-sg"
}




#private instances
variable "private_instance_type" {
  type    = string
  default = "t2.large"
}

variable "private_instance1_name" {
  type    = string
  default = "opensearch-1"
}

variable "private_instance2_name" {
  type    = string
  default = "opensearch-2"
}

variable "key_private" {
  type    = string
  default = "private-key.pem"
}

# gateways

variable "eip_name" {
  type    = string
  default = "elastic_ip_nat"
}

variable "nat_name" {
  type    = string
  default = "nat-gateway"
}
variable "igw_name" {
  type    = string
  default = "igw-gateway"
}

#public route table

variable "pub_routetable_name" {
  type    = string
  default = "public-route-table"
}


#public route table

variable "priv_routetable_name" {
  type    = string
  default = "private-route-table"
}

#target group

variable "tg_name" {
  type    = string
  default = "my-tg"

}
variable "tg_port" {
  type    = number
  default = 80

}
variable "tg_protocol" {
  type    = string
  default = "HTTP"

}
variable "tg_target_type" {
  type    = string
  default = "instance"
}

#load valancer 
variable "lb_name" {
  type    = string
  default = "my-lb"
}

variable "lb_type" {
  type    = string
  default = "application"

}
