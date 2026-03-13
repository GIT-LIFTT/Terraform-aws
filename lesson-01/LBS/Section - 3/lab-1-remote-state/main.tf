#The terraform block configures Terraform’s runtime rules.
#It does not create infrastructure
terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

#The provider block in Terraform configures the plugin 
#that Terraform uses to talk to a specific platform 
#(like AWS, Azure, or GitHub). It tells Terraform 
#how to authenticate, which region or endpoint to use,
# and any global settings needed before resources can be created

provider "aws" {
  region = "eu-west-2"
}

resource "aws_s3_bucket" "tf_state" {
    bucket = "jj-tf-state-remote-001"
}


resource "aws_dynamodb_table" "tf_lock" {
    name = "tf-state-lock"
    billing_mode = "PAY_PER_REQUEST"
    hash_key = "LockID"

    attribute {
        name = "LockID"
        type = "S"
    }
}