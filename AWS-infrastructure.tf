provider "aws" {
    region = "ap-south-1"
}

resource "aws_security_group" "microsg" {
    name = "microsg"
    description = "HTTP"
    vpc_id      = aws_vpc.microvpc.id

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"  
        cidr_blocks = ["0.0.0.0/0"]
    }
}
resource "aws_instance" "Amazonet2micro" {
  count = 1
  availability_zone = "ap-south-1a"
  ami = "ami-0fd05997b4dff7aac"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.micosubnet.id
  vpc_security_group_ids = [aws_security_group.microsg.id]
  key_name = "Lap-01"

  tags = {
    Name = "Amazon Instance"
  }
}