backend "s3" {
    bucket         = "harsh-viradia-terraform-bucket"
    key            = "terraform.tfstate"
    region         = "us-east-1"  
    encrypt        = true
  }