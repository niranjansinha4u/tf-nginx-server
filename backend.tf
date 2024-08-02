terraform {
  backend "s3" {
    bucket = "tf-nginx-server"
    key    = "tf-nginx/terraform.tfstate"
    region = "us-east-2"
  }
}