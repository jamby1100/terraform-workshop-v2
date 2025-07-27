terraform {
  required_providers {
    aws = {
      source    = "hashicorp/aws"
      version   = "~> 4.18.0"
    }
  }

  backend "s3" {
  
    # replace with the bucket you just created in the previous step
    bucket          = "jamby-tfstate"
    
    # if you have multiple state files in the same bucket you may have to replace this
    key             = "state/terraform_two.tfstate"
    
    # replace with the region you are assigned in
    region          = "us-east-2"
    encrypt         = true
  }
}