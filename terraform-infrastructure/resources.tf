
//create vpc 
resource "aws_vpc" "dzhelev-vpc" {
  cidr_block = "10.0.0.0/16"
}

//create internet gateway
resource "aws_internet_gateway" "dzhelev-igw" {
  vpc_id = aws_vpc.dzhelev-vpc.id
}

//create route table
resource "aws_route_table" "dzhelev-rt" {
  vpc_id = aws_vpc.dzhelev-vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.dzhelev-igw.id
    }
}

resource "aws_subnet" "dzhelev-subnet" {
  vpc_id     = aws_vpc.dzhelev-vpc.id
  cidr_block = "10.0.0.0/28"
  //specify availability zone
    availability_zone = "eu-central-1a"
}

//create subnet
resource "aws_subnet" "dzhelev-subnet2" {
  vpc_id     = aws_vpc.dzhelev-vpc.id
  cidr_block = "10.0.0.16/28"
  availability_zone =  "eu-central-1b"
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.dzhelev-subnet.id
  route_table_id = aws_route_table.dzhelev-rt.id
}

resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.dzhelev-subnet2.id
  route_table_id = aws_route_table.dzhelev-rt.id
}

//security group
resource "aws_security_group" "dzhelev-sg" {
  vpc_id = aws_vpc.dzhelev-vpc.id

  // Allow inbound HTTP traffic
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress  {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  // Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "dzhelev-sg"
  }
}