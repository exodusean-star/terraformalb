data "aws_vpc" "st1_ex_vpc" {
    filter {
        name = "tag:Name"
        values = ["st1-ex-vpc"]
    }
  
}
#서브넷 참조
data "aws_subnets" "st1_ex_public_subnet" {
    filter {
        name = "tag:Name"
        values = ["st1-ex-public-subnet-1", "st1-ex-public-subnet-2", "st1-ex-public-subnet-3"]
    }
}

data "aws_subnets" "st1_ex_private_subnet" {
    filter {
        name = "tag:Name"
        values = ["st1-ex-private-subnet-1", "st1-ex-private-subnet-2", "st1-ex-private-subnet-3"]
    }
}
#  보안 그룹 참조

data "aws_security_group" "st1_ex_http_sg" {
    filter {
        name = "tag:Name"
        values = ["st1-http-sg"]
    }
  
}

data "aws_security_group" "st1_ex_alb_sg" {
    filter {
        name = "tag:Name"
        values = ["st1-alb-sg"]
    }
  
}

data "aws_availability_zones" "available" {
    state = "available"
}