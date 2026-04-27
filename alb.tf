#1. 대상 그룹
resource "aws_lb_target_group" "st1_ex_docker_main_tg" {
    name = "st1-ex-docker-main-tg"
    port = 8080
    protocol = "HTTP"
    vpc_id = data.aws_vpc.st1_ex_vpc.id
    
    slow_start = 30
    deregistration_delay = 30 #인스턴스 종료시 기존 연결 유지 시간
    


    health_check {
      path = "/"
      protocol = "HTTP"
      interval = 30 #30 초마다 헬스체크
      timeout = 5 #5초안에 응답없으면 실패로 간주
      healthy_threshold = 2 #2번 연속 성공시 healthy
      unhealthy_threshold = 3 #3번 역속 실패시 unhealthy
    }

    tags = {name = "st1-ex-docker-main-tg"}

      
}



#2. 대상그룹의 인스턴스 추가
resource "aws_lb_target_group_attachment" "st1_ex_docker_main_tg_attachment" {
  #어느 대상 그룹에 등록할 것인가
  target_group_arn = aws_lb_target_group.st1_ex_docker_main_tg.arn
  target_id = aws_instance.st1_ex_alb_instance[0].id
  port = 8080 #대상 그룹의 포트와 일치해야함
  
}



#3. alb 생성
resource "aws_lb" "st1_ex_docker_alb" {
  name = "st1-ex-docker-alb"
  internal = false #내부 로드밸런서 설정
  load_balancer_type = "application"
  security_groups = [ data.aws_security_group.st1_ex_alb_sg.id ]
  subnets = [
    data.aws_subnets.st1_ex_public_subnet.ids[0],
    data.aws_subnets.st1_ex_public_subnet.ids[1]]
  tags = { name = "st1-ex-docker-alb"}

}


#4. ALB리스너 생성

resource "aws_lb_listener" "st1_ex_alb_https_listener" {
  load_balancer_arn = aws_lb.st1_ex_docker_alb.arn
  port = 443
  protocol = "HTTPS"
  ssl_policy = "ELBSecurityPolicy-2016-08"
  certificate_arn = "arn:aws:acm:ap-south-1:476293896981:certificate/cb5cc79c-9c9e-4336-94a7-b849736b8bf3"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.st1_ex_docker_main_tg.arn
  }
  tags = { name = "st1-ex-alb-https-listener"}
}

resource "aws_lb_listener" "st1_ex_alb_http_listener" {
  load_balancer_arn = aws_lb.st1_ex_docker_alb.arn
  port = 80
  protocol = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      protocol = "HTTPS"
      port = "443"
      status_code = "HTTP_301"
    }
  }
  tags = { name = "st1-ex-alb-http-listener"}
}