#provider.tf
provider "aws" {
    region = "ap-south-1" #cli환경설정값이 우선임
    #기본 태그 설정 : 테라폼으로 생성한 리소스들에 추가
    default_tags {
      tags = {
        project = "MSP-Solution-Architect-Training"
        owner = "st1"
        
        manageby = "terraform"
      }
    }
}