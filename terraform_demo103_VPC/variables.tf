variable "cidr" {
    description = "cidr range required for vpc"
    type = string
    default = "10.0.0.0/16"
  
}

variable "enable_dns_hostnames" {
    description = "enable dns hostname"
    type = bool
    default = null
  
}

variable "enable_dns_support" {
    description = "enable dns support"
    type = bool
    default = null
  
}


variable "vpc_name" {
    description = "tag for vpc"
    type = string
    default = "myvpc"

}

variable "igw_name" {
    description = "name of internet gateway"
    type = string
    default = "myigw"
  
}

variable "public_subnet_1_cidr" {
    description = "public subnet 1 cidr block"
    type = string
    default = "10.0.1.0/24"

}

variable "map_public_ip_on_launch" {
    description = "It will map the public ip while launching resources"
    type = bool
    default = null
  
}

variable "public_subnet_1_tag" {
    description = "name of pblic subnet 1 "
    type = string
    default = "pb_subnet_1"

}

### subnet 2

variable "public_subnet_2_cidr" {
    description = "cidr block for pb subnet 2"
    type = string
    default = "10.0.2.0/24"

}

variable "public_subnet_2_tag" {
    description = "tag for pblic subnet 2"
    type = string
    default = "pb_subnet_2"
  
}

### pr subnets

variable "private_subnet_1_cidr" {
    description = "cidr block for private subnet 1"
    type = string
    default = "10.0.5.0/24"
  
}

variable "pr_subnet_1_tag" {
    description = "tag for private subnet 1"
    type = string
    default = "pr_subnet_1"
  
}

variable "private_subnet_2_cidr" {
    description = "cidr block for private subnet 2"
    type = string
    default = "10.0.6.0/24"
  
}

variable "pr_subnet_2_tag" {
    description = "tag for private subnet 2"
    type = string
    default = "pr_subnet_2"

  
}

