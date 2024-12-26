resource "aws_vpc" "microvpc" {
    cidr_block = "10.8.0.0/16"
    tags = {
        Name = "vpc-for-micro"
    }
}

resource "aws_subnet" "micosubnet" {
  vpc_id = aws_vpc.microvpc.id
  availability_zone = "ap-south-1a"
  cidr_block = "10.8.1.0/24"
  tags = {
    Name = "subnet-for-micro"
  }
}
resource "aws_internet_gateway" "microgtw" {
  vpc_id = aws_vpc.microvpc.id

  tags = {
    Name = "gtw-for-micro"
  }
}
resource "aws_route_table" "micro_rt" {
    vpc_id = aws_vpc.microvpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.microgtw.id
    }
    tags = {
        Name = "rt-for-micro"
    }
}

resource "aws_route_table_association" "micro_rt_assoc" {
    subnet_id      = aws_subnet.micosubnet.id
    route_table_id = aws_route_table.micro_rt.id
}
