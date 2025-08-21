variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "my_state_bucket" {
  description = "S3 bucket name for Terraform state"
  type        = string
  default     = "andresr-devops-20250821"
}

variable "dynamodb_table" {
  description = "DynamoDB table name for state locking"
  type        = string
  default     = "terraform-locks"
}