resource "aws_vpc" "demo-vpc" {
    cidr_block = var.cidr
    enable_dns_hostnames = var.enable_dns_hostnames
    enable_dns_support = var.enable_dns_support

    tags = {
      "Name" = var.vpc_name
    }
}

## Internet gateway

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.demo-vpc.id

    tags = {
      "Name" = var.igw_name
    }
  
}

## public subnet

resource "aws_subnet" "public_subnet_1" {
    vpc_id = aws_vpc.demo-vpc.id
    cidr_block = var.public_subnet_1_cidr
    availability_zone = data.aws_availability_zones.east.names[0]
    map_public_ip_on_launch = var.map_public_ip_on_launch

    tags = {
      "Name" = var.public_subnet_1_tag
    }
  
}

resource "aws_subnet" "public_subnet_2" {
    vpc_id = aws_vpc.demo-vpc.id
    cidr_block = var.public_subnet_2_cidr
    availability_zone = data.aws_availability_zones.east.names[1]
    map_public_ip_on_launch = var.map_public_ip_on_launch

    tags = {
      "Name" = var.public_subnet_2_tag
    }
  
}

## private subnets

resource "aws_subnet" "private_subnet_1" {
    vpc_id = aws_vpc.demo-vpc.id
    cidr_block = var.private_subnet_1_cidr
    availability_zone = data.aws_availability_zones.east.names[0]
    map_public_ip_on_launch = false

  tags = {
    "Name" = var.pr_subnet_1_tag
  }
}

resource "aws_subnet" "private_subnet_2" {
    vpc_id = aws_vpc.demo-vpc.id
    cidr_block = var.private_subnet_2_cidr
    availability_zone = data.aws_availability_zones.east.names[1]
    map_public_ip_on_launch = false

    tags = {
      "Name" = var.pr_subnet_2_tag
    }
  
}

### public route table 

resource "aws_route_table" "public_route_table" {
    vpc_id = aws_vpc.demo-vpc.id

    tags = {
      "Name" = "public_rt"
    }
  
}

resource "aws_route" "public_internet_gateway" {
    route_table_id = aws_route_table.public_route_table.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  
}

### private route table

resource "aws_route_table" "private_route_table" {
    vpc_id = aws_vpc.demo-vpc.id

    tags = {
      "Name" = "private_rt"
    }
  
}

## subnets assiciation with rt

resource "aws_route_table_association" "public_rt_association_1" {
    subnet_id = aws_subnet.public_subnet_1.id
    route_table_id = aws_route_table.public_route_table.id 
}

resource "aws_route_table_association" "public_rt_association_2" {
    subnet_id = aws_subnet.public_subnet_2.id
    route_table_id = aws_route_table.public_route_table.id
  
}

resource "aws_route_table_association" "private_rt_association_1" {
    subnet_id = aws_subnet.private_subnet_1.id
    route_table_id = aws_route_table.private_route_table.id
  
}

resource "aws_route_table_association" "private_rt_association_2" {
    subnet_id = aws_subnet.private_subnet_2.id
    route_table_id = aws_route_table.private_route_table.id
  
}

### security group

resource "aws_security_group" "sg" {
    name = "my_security_group"
    description = "security group for new project"
    vpc_id = aws_vpc.demo-vpc.id

    ingress = [
        {
            description = "all traffic"
            from_port = 0
            to_port = 0
            protocol = "-1"
            cidr_blocks = ["0.0.0.0/0"]
            ipv6_cidr_blocks = null
            prefix_list_ids  = null
            security_groups  = null
            self             = null

        }
    ]

     egress = [
    {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      description      = "Outbound rule"
      prefix_list_ids  = null
      security_groups  = null
      self             = null
    }
  ]
tags = {
  "Name" = "pro_security_grp"
}
  
}


