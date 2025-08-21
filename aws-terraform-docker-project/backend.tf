terraform {
  backend "s3" {
    bucket         = "andresr-devops-20250821"   
    key            = "terraform/main.tfstate"    
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}