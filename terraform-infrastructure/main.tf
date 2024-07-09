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
  region  = "eu-central-1"
}

terraform {
  backend "s3"{
    bucket = "elsys-terraform-state"
    key = "terraform.tfstate"
    region = "eu-central-1"
    dynamodb_table = "tf_state_lock"
    encrypt = true
  }
}

# EC2 instance resources
resource "aws_instance" "dzhelev-webserver1" {
  ami           = "ami-0910ce22fbfa68e1d"
  tags = {
    Name = "dzhelev-webserver1"
  }
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.dzhelev-subnet.id
  key_name      = "itgix"
  vpc_security_group_ids = [aws_security_group.dzhelev-sg.id]
  associate_public_ip_address = true

  user_data = <<-EOF
  #!/bin/bash
  sudo yum update -y
  sudo yum install httpd -y
  sudo systemctl start httpd
  sudo systemctl enable httpd
  sudo echo "web 1" >> /var/www/html/index.html
  EOF
}

resource "aws_instance" "dzhelev-webserver2" {
  ami           = "ami-0910ce22fbfa68e1d"
    tags = {
    Name = "dzhelev-webserver2"
  }
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.dzhelev-subnet.id
  key_name      = "itgix"
  vpc_security_group_ids = [aws_security_group.dzhelev-sg.id]
  associate_public_ip_address = true

  user_data = <<-EOF
  #!/bin/bash
  sudo yum update -y
  sudo yum install httpd -y
  sudo systemctl start httpd
  sudo systemctl enable httpd
  sudo echo "web 2" >> /var/www/html/index.html
  EOF
}

resource "aws_lb" "lb1" {
  name               = "dzhelev-lb1"
  internal           = false
  load_balancer_type = "application"
  subnets = [aws_subnet.dzhelev-subnet.id, aws_subnet.dzhelev-subnet2.id]

  security_groups = [aws_security_group.dzhelev-sg.id]
}

resource "aws_lb_target_group" "tg1" {
  vpc_id   = aws_vpc.dzhelev-vpc.id
  name     = "dzhelev-tg1"
  port     = 80
  protocol = "HTTP"

  health_check {
    path = "/"
  }
}


resource "aws_lb_listener" "tg1" {
  load_balancer_arn = aws_lb.lb1.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg1.arn
  }
}

resource "aws_lb_target_group_attachment" "tgw1" {
  target_group_arn = aws_lb_target_group.tg1.arn
    target_id = "${aws_instance.dzhelev-webserver1.id}"
  port = 80
}

resource "aws_lb_target_group_attachment" "tgw2" {
  target_group_arn = aws_lb_target_group.tg1.arn
  target_id = "${aws_instance.dzhelev-webserver2.id}"
  port = 80
}


