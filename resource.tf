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

resource "aws_security_group_rule" "st1_ex_http_sg_public" {
    type              = "ingress"
    from_port         = 8080
    to_port           = 8080
    protocol          = "tcp"
    cidr_blocks       = ["0.0.0.0/0"]
    security_group_id = data.aws_security_group.st1_ex_http_sg.id
}

resource "aws_security_group_rule" "st1_ex_http_sg_fastapi" {
    type              = "ingress"
    from_port         = 8000
    to_port           = 8000
    protocol          = "tcp"
    cidr_blocks       = ["0.0.0.0/0"]
    security_group_id = data.aws_security_group.st1_ex_http_sg.id
}

resource "aws_security_group_rule" "st1_ex_http_sg_ssh" {
    type              = "ingress"
    from_port         = 22
    to_port           = 22
    protocol          = "tcp"
    cidr_blocks       = ["0.0.0.0/0"]
    security_group_id = data.aws_security_group.st1_ex_http_sg.id
}

data "aws_key_pair" "st1_key_2" {
  key_name = "st1-key-2"
}
resource "aws_instance" "st1_ex_alb_instance" {
  count         = 1
  ami           = "ami-0e12ffc2dd465f6e4"
  instance_type = "t3.micro"

  #퍼블릭 서브넷의 ID를 참조하여 연결합니다.
    subnet_id = data.aws_subnets.st1_ex_public_subnet.ids[count.index]
    associate_public_ip_address = true
  #볼륨 지정
    root_block_device {
        volume_size = 10
        volume_type = "gp3"
        delete_on_termination = true #인스턴스 삭제시 함께 삭제
    }
    key_name = data.aws_key_pair.st1_key_2.key_name

    user_data = <<-EOF
      #!/bin/bash
      FLAG_FILE="/var/log/first-boot-done"
      if [ -f "$FLAG_FILE" ]; then
          exit 0
      fi

      dnf update -y
      dnf install -y docker wget

      mkdir -p /usr/local/lib/docker/cli-plugins
      curl -SL https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64 \
        -o /usr/local/lib/docker/cli-plugins/docker-compose
      chmod +x /usr/local/lib/docker/cli-plugins/docker-compose

      systemctl enable --now docker
      usermod -aG docker ec2-user

      mkdir -p /opt/ian-alb-project && cd /opt/ian-alb-project
      wget https://raw.githubusercontent.com/exodusean-star/terraformalb/refs/heads/main/docker-compose-alb-change.yaml

      docker compose -f docker-compose-alb-change.yaml up -d --pull always

      date > "$FLAG_FILE"
      echo "Terraform App Instance Setup Complete" >> "$FLAG_FILE"
    EOF

    #보안 그룹 설정
    vpc_security_group_ids = [
        data.aws_security_group.st1_ex_http_sg.id,
        data.aws_security_group.st1_ex_alb_sg.id
        ]
  tags = {
    Name = "st1_ex_alb_instance"
  }

}

  