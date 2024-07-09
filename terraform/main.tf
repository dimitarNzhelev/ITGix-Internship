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

# resource "aws_instance" "ec2_instance" {
#   ami           = "ami-0910ce22fbfa68e1d"
#   instance_type = "t3.micro"
#   key_name = "itgix"
#   subnet_id = "subnet-0a06200c10a84ebf8"
#   tags = {
#     Name = "ExampleDimitarZhelevInstance"
#   }
# }

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "dzhelev-intern-module"

  ami                    = "ami-0910ce22fbfa68e1d"
  instance_type          = "t3.micro"
  key_name               = "itgix"
  monitoring             = true
  subnet_id              = "subnet-0a06200c10a84ebf8"

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}