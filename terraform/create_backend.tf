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


resource "aws_s3_bucket" "elsys-terraform-state" {
  bucket = "elsys-terraform-state"

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name = "elsys-terraform-state"
  }
}



resource "aws_s3_bucket_versioning" "elsys-terraform-state_example" {
  bucket = "elsys-terraform-state"
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_dynamodb_table" "elsys-tf-state" {
  name = "tf_state_lock"
  hash_key = "LockID"
  read_capacity = "8"
  write_capacity = "8"

  attribute {
    name = "LockID"
    type = "S"
  }
  
  tags = {
    Name = "tfStateLock"
  }
  
  depends_on = [
    aws_s3_bucket.elsys-terraform-state
  ]
}
