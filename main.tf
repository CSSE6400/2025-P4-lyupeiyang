terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region                  = "us-east-1"
  shared_credentials_files = ["./credentials"]

  default_tags {
    tags = {
      Environment = "Dev"
      Course      = "CSSE6400"
      StudentID   = "s4871984"
    }
  }
}

resource "aws_instance" "hextris-server" {
  ami             = "ami-08b5b3a93ed654d19"
  instance_type   = "t2.micro"
  key_name        = "vockey"
  security_groups = [aws_security_group.hextris-server.name]

  user_data = file("./serve-hextris.sh")

  tags = {
    Name = "hextris"
  }
}

resource "aws_security_group" "hextris-server" {
  name        = "hextris-server"
  description = "Hextris HTTP and SSH access"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "hextris-url" {
  value = aws_instance.hextris-server.public_ip
}