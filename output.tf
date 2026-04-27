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

output "az_names" {
    value = data.aws_availability_zones.available.names
    description = "사용 가능한 가용영역 정보"

}

# dns출력
output "docker_alb_dns_name" {
    value = aws_lb.st1_ex_docker_alb.dns_name
    description = "ALB의 DNS이름"
  
}