resource "aws_security_group_rule" "st1_ex_http_sg" {
    type = "ingress"
    from_port = 8080
    to_port = 8085
    protocol = "tcp"
    
    #이 규칙을 어디에 추가할 것인가
    security_group_id = data.aws_security_group.st1_ex_http_sg.id

    #이 규칙의 소스는 무엇을 사용할 것인가
    source_security_group_id = data.aws_security_group.st1_ex_alb_sg.id
}    