########################################
# main.tf: main terraform script
########################################

# connect to aws
provider "aws" {
  region     = var.region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins_sg"
  description = "Allow Jenkins Traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow from Personal CIDR block"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = var.cidr_block
  }

  ingress {
    description = "Allow SSH from Personal CIDR block"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.cidr_block
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "Jenkins SG"
  }
}

# locals tags
locals {
  tags = {
    "app"         = "jenkins-build-master"
    "costcenter"  = "0000000"
    "environment" = "dev"
  }
}

# to-do: add a name for the EC2 instance
resource "aws_instance" "web" {
  ami             = var.ami_id
  instance_type   = var.instance_type
  key_name        = var.aws_ec2_key
  security_groups = [aws_security_group.jenkins_sg.name]
  user_data       = file("install_jenkins.sh")
  tags            = local.tags
}
