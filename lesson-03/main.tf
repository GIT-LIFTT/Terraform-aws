terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-east-2"
}

provider "aws" {
  alias = "provider2"
  region = "us-east-1"
}


resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.tf-vpc.id
  cidr_block = "10.1.1.0/24"

  tags = {
    Name = "tf-subnet"
  }
  depends_on = [ aws_vpc.tf-vpc ]
}
resource "aws_vpc" "tf-vpc" {
  provider = aws.provider2
  cidr_block = "10.1.0.0/16"
  
  tags = {
    Name = "terraform-vpc"
  }
}

resource "aws_instance" "lesson_03" {
  ami           = "ami-0c7c4e3c6b4941f0f"
  instance_type = "t2.micro"

  tags = {
    Name = "Lesson-03-AWS-Instance"
  }
}