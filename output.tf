output "vpc_id" {
    value = data.aws_vpc.st1_ex_vpc.id  

  
}
output "public_subnet_ids" {
    value = data.aws_subnets.st1_ex_public_subnet.ids
}
output "private_subnet_ids" {
    value = data.aws_subnets.st1_ex_private_subnet.ids
}
output "http_sg_id" {
    value = data.aws_security_group.st1_ex_http_sg.id
}