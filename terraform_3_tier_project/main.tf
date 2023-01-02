

##project_vpc
###vpc

resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = null
  enable_dns_support   = null

  tags = {
    "Name" = "myvpc"
  }

}

##internet gateway

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    "Name" = "my-igw"
  }

}

## creating elastic ip

resource "aws_eip" "eip" {
  depends_on = [aws_internet_gateway.igw]

}

## nat gateway

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public_subnet_1.id
  depends_on    = [aws_eip.eip]
  tags = {
    "Name" = "my-nat"
  }

}


##route table publi

resource "aws_route_table" "pbrt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    "Name" = "public-rt"
  }

}

# private route table 

resource "aws_route_table" "prt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    "Name" = "private-rt"
  }

}

## database route table

resource "aws_route_table" "dbrt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    "Name" = "database-rt"
  }

}

##subnet

resource "aws_subnet" "public_subnet_1" {
  vpc_id            = aws_vpc.vpc.id
  availability_zone = data.aws_availability_zones.az.names[0]
  cidr_block        = "10.0.1.0/24"

  tags = {
    "Name" = "public-subnet-1"
  }

}

resource "aws_subnet" "public_subnet_2" {
  vpc_id            = aws_vpc.vpc.id
  availability_zone = data.aws_availability_zones.az.names[1]
  cidr_block        = "10.0.2.0/24"

  tags = {
    "Name" = "public-subnet-2"
  }

}

resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.vpc.id
  availability_zone = data.aws_availability_zones.az.names[0]
  cidr_block        = "10.0.3.0/24"

  tags = {
    "Name" = "private-subnet-1"
  }

}


resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.vpc.id
  availability_zone = data.aws_availability_zones.az.names[1]
  cidr_block        = "10.0.4.0/24"

  tags = {
    "Name" = "private-subnet-2"
  }

}

resource "aws_subnet" "database_subnet_1" {
  vpc_id            = aws_vpc.vpc.id
  availability_zone = data.aws_availability_zones.az.names[0]
  cidr_block        = "10.0.5.0/24"
  tags = {
    "Name" = "database-subnet-1"
  }

}

resource "aws_subnet" "database_subnet_2" {
  vpc_id            = aws_vpc.vpc.id
  availability_zone = data.aws_availability_zones.az.names[1]
  cidr_block        = "10.0.6.0/24"
  tags = {
    "Name" = "database-subnet-2"
  }

}

##subnet association

resource "aws_route_table_association" "public_rta_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.pbrt.id

}

resource "aws_route_table_association" "public_rta_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.pbrt.id

}

resource "aws_route_table_association" "private_rta_1" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.prt.id

}

resource "aws_route_table_association" "private_rta_2" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.prt.id

}

resource "aws_route_table_association" "database_rta_1" {
  subnet_id      = aws_subnet.database_subnet_1.id
  route_table_id = aws_route_table.dbrt.id

}

resource "aws_route_table_association" "database_rta_2" {
  subnet_id      = aws_subnet.database_subnet_2.id
  route_table_id = aws_route_table.dbrt.id

}

## security group for jump server

resource "aws_security_group" "js" {
  name        = "jump-server-sg"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "https"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "http"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "jump-server-sg"
  }
}

## security group for load balancer

resource "aws_security_group" "lb" {
  name        = "load-balancer-sg"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.vpc.id


  ingress {
    description = "http"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "load-balancer-sg"
  }
}

## security group for autoscale

resource "aws_security_group" "as" {
  name        = "autoscale-sg"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.vpc.id


  ingress {
    description     = "ssh"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.js.id]

  }

  ingress {
    description = "http"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.lb.id]
   
  }


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "autoscale-sg"
  }
}

## security group for database

resource "aws_security_group" "db" {
  name        = "mysql-database-sg"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.vpc.id


  ingress {
    description     = "mysql"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.as.id]
  }


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "database-sg"
  }
}

## mysql database 

resource "aws_db_instance" "db_instance" {
  engine                   = "mysql"
  db_name                  = "db_manoj"
  username                 = "admin"
  password                 = "Admin.1122"
  skip_final_snapshot      = true
  db_subnet_group_name     = aws_db_subnet_group.db_subnet_group.id
  delete_automated_backups = true
  multi_az                 = false
  publicly_accessible      = false
  instance_class           = "db.t2.micro"
  allocated_storage        = 20
  vpc_security_group_ids   = [aws_security_group.db.id]

}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "sub-group"
  subnet_ids = [aws_subnet.database_subnet_1.id, aws_subnet.database_subnet_2.id]

  tags = {
    "Name" = "new-db-subnet-group"
  }

}

## load balancer

resource "aws_lb" "my-lb" {
  name                       = "myloadbalancer"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.lb.id]
  enable_deletion_protection = false
  subnet_mapping {
    subnet_id = aws_subnet.public_subnet_1.id
  }
  subnet_mapping {
    subnet_id = aws_subnet.public_subnet_2.id
  }
}

## target group

resource "aws_alb_target_group" "tg" {
  name     = "my-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id

}

## listener

resource "aws_alb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.my-lb.arn
  port              = "80"
  protocol          = "HTTP"


  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.tg.arn
  }

}


## launch configuration

resource "aws_launch_configuration" "lc" {
  name_prefix                 = "my-lc"
  image_id                    = "ami-0b5eea76982371e91"
  instance_type               = "t2.micro"
  user_data                   = data.template_file.user_data.rendered
  key_name                    = "newkey"
  associate_public_ip_address = false
  security_groups             = [aws_security_group.as.id]

}



## autoscaling group

resource "aws_autoscaling_group" "asg" {
  name                 = "my-as-group"
  vpc_zone_identifier  = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]
  min_size             = 2
  max_size             = 4
  desired_capacity     = 2
  launch_configuration = aws_launch_configuration.lc.name
  target_group_arns    = [aws_alb_target_group.tg.arn]

  tag {
    key                 = "Name"
    value               = "private_app_server"
    propagate_at_launch = true
  }
  depends_on = [
    aws_alb_target_group.tg
  ]
}



## ec2 instance

resource "aws_instance" "server" {
  ami                         = "ami-0b5eea76982371e91"
  instance_type               = var.instance_type
  key_name                    = "newkey"
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.public_subnet_1.id
  vpc_security_group_ids      = [aws_security_group.js.id]




  tags = {
    Name  = "jump_server"
    Owner = "mady"
  }

}




