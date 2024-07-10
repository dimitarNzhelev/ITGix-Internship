resource "aws_vpc" "mdp-vpc" {
  cidr_block = "10.0.0.0/27"
}

resource "aws_subnet" "mdp-subnet" {
  vpc_id     = aws_vpc.mdp-vpc.id
  cidr_block = "10.0.0.0/28"
  availability_zone = "eu-central-1a"
}

resource "aws_internet_gateway" "mdp-igw" {
  vpc_id = aws_vpc.mdp-vpc.id
}

resource "aws_route_table" "mdp-rt" {
  vpc_id = aws_vpc.mdp-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.mdp-igw.id
  }
}

resource "aws_route_table_association" "mdp-subnet-association" {
  subnet_id = aws_subnet.mdp-subnet.id
  route_table_id = aws_route_table.mdp-rt.id
}