provider "aws" {
  region = "us-east-1"
  access_key = "AKIAZPIL4F3PP56BMU6L"
  secret_key = "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"
}
resource "aws_vpc" "my_vpc" {
  cidr_block = "192.168.0.0/16"
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "192.168.1.0/24"
  availability_zone       = "us-east-1a"
}

resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "192.168.2.0/24"
  availability_zone       = "us-east-1b"
}
resource "aws_instance" my_instance {
  ami           = "ami-04cb4ca688797756f" 
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet.id

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 8
    delete_on_termination = true
  }

  tags = {
    "Name"    = "Application_server"
    "purpose" = "Assignment"
  }

  key_name = "myec2key2"
}
resource "aws_security_group" "my_security_group" {
  name        = "my-security-group"
  description = "My Security Group"
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
resource "aws_network_interface_sg_attachment" "my_sg_attachment" {
  security_group_id    = aws_security_group.my_security_group.id
  network_interface_id = aws_instance.my_instance.network_interface_ids[0]
}

