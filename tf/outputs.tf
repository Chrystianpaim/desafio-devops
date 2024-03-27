output "sg_deveqi_api_id" {
  value = aws_security_group.sg-devglobo.id
}



output "subnet_ida1" {
  value = aws_subnet.devglobo-public-a.id

}
output "subnet_ida2" {
  value = aws_subnet.devglobo-public-b.id

}

output "vpc_id" {
  value = aws_vpc.vpc_devglobo.id
}

