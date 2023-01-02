output "eip" {
  value = aws_eip.eip.public_ip

}

output "vpc_id" {
  value = aws_vpc.vpc.id

}

output "lb_dns" {
  value = aws_lb.my-lb.dns_name

}


output "rds_addres" {
  value = aws_db_instance.db_instance.address

}

