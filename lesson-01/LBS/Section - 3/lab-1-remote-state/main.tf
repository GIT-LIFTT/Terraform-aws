#The terraform block configures Terraform’s runtime rules.
#It does not create infrastructure
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
    backend "s3" {
    bucket         = "jj-tf-state-remote-001"
    key            = "envs/dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "tf-state-lock"
    encrypt        = true
  }
}

#The provider block in Terraform configures the plugin 
#that Terraform uses to talk to a specific platform 
#(like AWS, Azure, or GitHub). It tells Terraform 
#how to authenticate, which region or endpoint to use,
# and any global settings needed before resources can be created

provider "aws" {
  region = "us‑east‑1"
}

#creates a s3 bucket which is to be used for terraform state 
resource "aws_s3_bucket" "tf_state" {
    bucket = "jj-tf-state-remote-001"
}


#creates a dynamodb whcih is to be used to handle tf state locking 
#ensuring that only one person is accessing the state file at a time 
# this porevents it dfrom becoming corrupt 
resource "aws_dynamodb_table" "tf_lock" {
    name = "tf-state-lock"
    billing_mode = "PAY_PER_REQUEST"
    hash_key = "LockID"

    attribute {
        name = "LockID"
        type = "S"
    }
}




