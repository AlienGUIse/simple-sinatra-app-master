#Use s3 to store the state of the infrastructure.
terraform {
  required_version = ">= 0.12"

  backend "s3" {
    encrypt = false
    bucket = "simple-sinatra"
    region="ap-southeast-2"
    key="simple-sinatra-ecs.tfstate"

  }
}

provider "aws" {
  region = "ap-southeast-2"
}