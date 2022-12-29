

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
  allocated_storage        = "20"
  vpc_security_group_ids   = [data.aws_security_group.db-sg.id]
}



resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "sub_group"
  subnet_ids = data.aws_subnets.available_database_subnets.ids

  tags = {
    "Name" = "new_db_subnet_group"
  }

}