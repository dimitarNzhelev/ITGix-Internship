terraform {
  backend "s3"{
    bucket = "elsys-mrejari-terraform-state"
    key = "terraform.tfstate"
    region = "eu-central-1"
    dynamodb_table = "elsys-mrejari_tf_state_lock"
    encrypt = true
  }
}